From: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 0/3] cgroup2: introduce cpuset.mems.migration
Date: Thu, 22 Apr 2021 17:06:05 +0800
Message-ID: <20210422090608.7160-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EYXXwg5Y7nC4zs4zd2VmOocoYMpttk3QU3l+Cpc74uo=;
        b=YXceGHI6kIHAxxpMboOHb4OMSuGJ1q1HQYajf8Oq91oaFhbUUXfo9Ss0O8W2UcJ1PB
         q492iPRf6fKko2cX3x0i2aKzA4lD1NiIKEuEKU1e94mzyqcqwzkiNXDr4icU0y1+YS88
         BOnXqeFXYHoNAeJoNfg1DGIj0EKEG8UPfAIrO5s739t5F1RmzCkuCV7DY+Led05gXT6G
         j7kwgC1EULkycVVIVdmDJHm2j0KgH3hTDq81cRGMjwpdEivWXbzcVMwFL3bhUKPClb5d
         IIJiclrreuoAp4iWy7dVXZCLp2Uz4JK3fZpuOjyL8OnoR5NFeiUTPd99eOG8a206hmxw
         Iy9g==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Some of our services are quite performance sensitive and
actually NUMA-aware designed, aka numa-service. The SLOs
can be easily violated when co-locate numa-services with
other workloads. Thus they are granted to occupy the whole
NUMA node and when such assignment applies, the workload
on that node needs to be moved away fast and complete.

This new cgroup v2 interface is an enhancement of cgroup
v1 interface cpuset.memory_migrate by adding a new mode
called "lazy". With the help of the "lazy" mode migration
we solved the aforementioned problem on fast eviction.

Patch 1 applies cpusets limits to tasks that using default
memory policies, which makes pages inside mems_allowed are
preferred when autoNUMA is enabled. This is also necessary
for the “lazy” mode of cpuset.mems.migration.

Patch 2&3 introduce cpuset.mems.migration, see the patches
for detailed information please.

Abel Wu (3):
  mm/mempolicy: apply cpuset limits to tasks using default policy
  cgroup/cpuset: introduce cpuset.mems.migration
  docs/admin-guide/cgroup-v2: add cpuset.mems.migration

 Documentation/admin-guide/cgroup-v2.rst |  36 ++++++++
 kernel/cgroup/cpuset.c                  | 104 +++++++++++++++++++-----
 mm/mempolicy.c                          |   7 +-
 3 files changed, 124 insertions(+), 23 deletions(-)

-- 
2.31.1

