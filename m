From: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: noprefix mount option
Date: Fri, 29 Nov 2013 16:36:49 +0200
Message-ID: <CAGXs5wVd-fD5xcFJbeN-uSbEKczYuDbBp0BE=vhuM34eBgsqXA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=YfhR9uovm9J8ZZIBvYuLfMEjlEDFvACayOpMv6rTJzA=;
        b=QcKflSLj1keEbn9r6Tj+lXugoAaEuccS7ycl+zo8f+ZHgOJZcYWyb4EchH3Nt9uGYE
         8y/MTnB8Y4igOc8lwTVmSZSecBvLU/KX6Fhg2v4ZQE7fZOVKxEBpUG1o1AGjp9RHOhfg
         eAK7eytaCJzZt9jESpESUJibowrJBQ/cGKFiepr5gClU+LC5cTdb2+DwHpdnpsjg1JCf
         lkBp0e8HGN/nCPEONwq2zH83pX1p4uO5iyA72yqWylspJO4/GOB+w7NXNQYmmTlnqGp+
         LWyEJ7AwmnGCLo81uXGJFmwFzqlHVRHZ3fqtgCzjquZmig+zE192jGBxppYFQloK0GpU
         HHVg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,
I hope this is the right place to ask.
As far as I know, the noprefix mount option is valid only for cpuset.

I ran the following sequence of Fedora 18, 3.6.10-4.fc18.x86_64:

mkdir /mytest
mount -t tmpfs testcg /mytest
mkdir /mytest/testprefix
mount -t cgroup -o noprefix,cpuset  testnonprefix /mytest/testprefix/

I expected that entries under /mytest/testprefix/ will be without the
"cpuset" prefix. However, this is what I get:

ls /mytest/testprefix/
cgroup.clone_children       cpuset.memory_pressure_enabled
cgroup.event_control        cpuset.memory_spread_page
cgroup.procs                   cpuset.memory_spread_slab
cpuset.cpu_exclusive        cpuset.mems
cpuset.cpus                     cpuset.sched_load_balance
cpuset.mem_exclusive      cpuset.sched_relax_domain_level
cpuset.mem_hardwall       notify_on_release
cpuset.memory_migrate    release_agent
cpuset.memory_pressure  tasks


any ideas ? Am I missing something ?

regards,
Kevin
