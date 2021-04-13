From: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Subject: [PATCH 0/2] Relax cpuset validation for cgroup v2
Date: Tue, 13 Apr 2021 11:02:33 +0200
Message-ID: <20210413090235.1903026-1-odin@uged.al>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RzM4K64HP+ENrA/kOG1Fm4dQKmRzcsmui7InMaV8aSU=;
        b=F4W7kx3mGrFdIG/6Akw+ma0TN0uhnUoqlb1MQJGLG0wOGyKksu0k4QGwYhmYEnD3F1
         HR0OfFx3pAagCxh1pitD+GIPOIcOBms5zp0uLTqNnNLxT2r9Abh8iWXu289sIJBoqNqU
         E54+BnBUAOgRUaG2awx7fcufOtsDhyjRqWI5h3qvBQwv2TQ7u6JJ1LgzBsaQrpRQDsKN
         gduXxMYNK8CsH5VQRmFdfXzApbwHl3w8ESQtAY6F55Uz9L0vDJxIaSggrhIDJNw3HuRr
         g/puRMRLWX3sep1bobm5LitZ4dMTz8/H2R4RS939BhZ9H76apYYKhEIHRF5NgB2wNE7e
         +oig==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>

Two small validation relaxations for cgroup v2, making it easier to
manage the hierarchy without the current pain points. Both changes
work for both mems and cpus (but I have no NUMA machine to test mems).

Hopefully the patches has an ok description about what change they
provide, and why they are helpful.

Odin Ugedal (2):
  cgroup2: cpuset: Disable subset validation on set
  cgroup2: cpuset: Always allow setting empty cpuset

 kernel/cgroup/cpuset.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

-- 
2.31.0

