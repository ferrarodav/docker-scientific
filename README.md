# Experiment with Data Science

The Docker container is based on the `python:3.6` container and has many packages to do numerical computation and visualize data:
Numpy, Cython, OpenCV (and opencv-python), Matplotlib, Pandas, Seaborn, Scipy, Scikit-learn, Scikit-image, Jupyter (and the extensions configurator), Xgboost, H5py, Requests, Pillow, Networkx.

It also has [Sacred](https://github.com/IDSIA/sacred), a tool to help you configure, organize, log and reproduce experiments developed at IDSIA.
The packages needed to keep track of the code (git), use a mongo database, yaml configuration and a telegram bot notifier are included.

Jupyter is run on port 8080.

## Run with database and omniboard
[Omniboard](https://github.com/vivekratnavel/omniboard) is a web dashboard for the Sacred machine learning experiment management tool.
You can download the `docker-compose.yml` file in this repository to run the Jupyter server, the database and omniboard all together.

It needs two environment variables:
- CODE: the folder to mount in the Jupyter server
- DB_NAME: the name of the database that omniboard should look to.

Here an example:
```bash
export CODE="/ABSOLUTE/PATH/TO/CODE/FOLDER"
export DB_NAME="EXPERIMENT"
docker swarm init
docker stack deploy -c docker-compose.yml STACKNAME
```

## Run Jupyter server alone
You can run it directly:
```bash
docker pull ferrarodav/scientific
docker run -p 8080:8080 -v /PATH/TO/FOLDER:/home/workspace --name CONTAINERNAME ferrarodav/scientific
```
