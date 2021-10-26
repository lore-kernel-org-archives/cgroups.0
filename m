From: Barry Song <21cnbao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC] cpuset: Make cpusets get restored on hotplug
Date: Wed, 27 Oct 2021 12:58:08 +1300
Message-ID: <20211026235808.34168-1-21cnbao@gmail.com>
References: <972a5c1b-6721-ac20-cec5-617af67e617d@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=caC3B6GjKaBRDDR0pkhw6AqjE4SAmcqhSKEygWuTBsQ=;
        b=pC0e/FlNdelKbXYwhK+ASlyQ5jzvhyztGiS4zvZ3CE59AtXj3P7UhJNSDsDLFS10NW
         bHNo2VacxvFTNet+iaahlaLRCmOFithcpZmhp2Dyl6/b/8R3PoY36vxl2TtQaTNRXdSg
         CuFRnhkffVpMd8G9QXkq6neQkMUYe+9BL2ifcdLaRhxes3I3k6lHoJiYtdrkTSNIGHdB
         wOm86JNvdOCP4sf+lbUiMdF0QWxMcSUi4eCaO9lEI17vbJGK78D7ezdk9pMwhLtYAemi
         pFGdPxjQATyD5onLIo4orkKVqiTxHkB3v4DXyaASas0vdEWlUf/Jn68mZ/q4/949n5OT
         Yhpg==
In-Reply-To: <972a5c1b-6721-ac20-cec5-617af67e617d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org, jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, kerrnel-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vpillai-tWEdnPwa2b6ifxm/DiOjgA@public.gmane.org

> I think Tejun is concerned about a change in the default behavior of
> cpuset v1.
>
> There is a special v2 mode for cpuset that is enabled by the mount
> option "cpuset_v2_mode". This causes the cpuset v1 to adopt some of the
> v2 behavior. I introduced this v2 mode a while back to address, I think,
> a similar concern. Could you try that to see if it is able to address
> your problem? If not, you can make some code adjustment within the
> framework of the v2 mode. As long as it is an opt-in, I think we are
> open to further change.

I am also able to reproduce on Ubuntu 21.04 LTS.

all docker will be put in this cgroups and its child cgroups:
/sys/fs/cgroup/cpuset/docker

disabling and enabling SMT by:
echo off > /sys/devices/system/cpu/smt/control
echo on > /sys/devices/system/cpu/smt/control

or unpluging and pluging CPUs by:
echo 0 > /sys/devices/system/cpu/cpuX/online
echo 1 > /sys/devices/system/cpu/cpuX/online

then all docker images will lose some CPUs.

So should we document the broken behaviours somewhere?

Thanks
barry
