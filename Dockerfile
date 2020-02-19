
# Use an official Python runtime as a parent image
FROM python:3.6.7
LABEL maintainer "innopearl"

# Create a new system user
RUN useradd -ms /bin/bash jupyter


# Set the working directory to /home/jupyter
WORKDIR /home/jupyter

# Copy the current directory contents into the container at /home/jupyter
COPY requirements.txt /home/jupyter

#openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mykey.key -out mycert.pem << EOF
#US
#New York
#New York City
#Your Organization
#Organizational Unit Name
#Common Name (e.g. server FQDN or YOUR name)
#Email@Domain.com
#EOF
COPY mycert.pem  /home/jupyter
COPY mykey.key /home/jupyter
RUN chown jupyter /home/jupyter/mycert.pem
RUN chown jupyter /home/jupyter/mykey.key


# Install dependencies: e.g. ta-lib
#RUN apt install build-essential wget -y
RUN wget https://artiya4u.keybase.pub/TA-lib/ta-lib-0.4.0-src.tar.gz
RUN tar -xvf ta-lib-0.4.0-src.tar.gz
WORKDIR /home/jupyter/ta-lib/
RUN ./configure --prefix=/usr
RUN make
RUN make install

# Install any needed packages specified in requirements.txt
RUN pip install --upgrade pip
RUN pip install --trusted-host pypi.python.org -r /home/jupyter/requirements.txt

# Make port 8888 available to the world outside this container
EXPOSE 8888

# Change to this new user
USER jupyter

# Define environment variable
ENV DESCRIPTION "zipline"
ENV ZIPLINE_ROOT "/home/jupyter/zipline"
RUN jupyter notebook --generate-config

#launch python from a console then type
#from IPython.lib import passwd
#password = passwd("secret")
#password
RUN echo "c.NotebookApp.password = u'sha1:5517bdc0e515:284f423ec6c27f090d5509bf6f31a1754c643a3a'" >> /home/jupyter/.jupyter/jupyter_notebook_config.py

# Start the jupyter notebook
RUN mkdir -p /home/jupyter/notebooks && chown jupyter:jupyter /home/jupyter/notebooks
RUN mkdir -p /home/jupyter/zipline && chown jupyter:jupyter /home/jupyter/zipline
WORKDIR /home/jupyter/notebooks
ENTRYPOINT ["jupyter", "notebook", "--ip=*", "--certfile=/home/jupyter/mycert.pem", "--keyfile", "/home/jupyter/mykey.key"]
