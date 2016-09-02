From: Sverd Johnsen <sverd.johnsen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: Why would cpu cgroup get disabled by the kernel?
Date: Fri, 2 Sep 2016 13:49:44 +0200
Message-ID: <CAGmahrTwRC3cr72S2sJC9pzCxuGmYeWHe-iprz9D20DDDvU7MA@mail.gmail.com>
References: <CAGmahrS4P7kS6_5MOhHA=ge6mcq0C2f85iN9S3z5dgi+qsEh9g@mail.gmail.com>
 <9B0331B6EBBD0E4684FBFAEDA55776F92CE0E032@HASMSX110.ger.corp.intel.com> <57C94D7E.4090204@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qk1SjfS/sNsXqbqqlHn6UzrNGQu6kYJAqNnWHCq/2V4=;
        b=Ah3yIs1G75l4HMsYEjGDgJp2vcMZANUmm4kGDMw+NukR8BmDc6hyJk8W7ti4Hz57ve
         Pj+G7mgsz8QFrYsRx62mN7gPLe4PZsI59/EZmGYt7jdLpfXNNlm3zbyA3l55f/oONuBp
         SZ7B5I2jiQTOypJ5zc4mbN19xlZ3nNH71C7f51R1G0O+M0NvduzVPbe3Sezy75xeqrxF
         S0k+bYFMnqna51NacdVGUaRhtzJCoqGba7Ve18vjsG0M9I9LlhY74AyTJEPBhSGoh5V5
         VeDXQPDBFyvxdBqhF9I/A31M2/+3XfsmAucFr12pgXPkvul0DxHgBSTWUSjhyGeHi+CB
         QgoA==
In-Reply-To: <57C94D7E.4090204-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "Rosen, Rami" <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

/proc/cmdline and CONFIG_CMDLINE are just the standard options (root
console etc.), nothing regarging cgroups. cgroup_disable does not get
used anywhere..dont you think I would have thought of that.

On 2 September 2016 at 11:59, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> On 2016/9/2 17:44, Rosen, Rami wrote:
>> Hi, Sverd,
>>
>> Could it be that you are using the cgroup_nov1=3Dall kernel option (or i=
nclude cpu in cgroup_nov1=3D... bitmask)?
>> What does cat /proc/cmdline show ?
>>
>
> If the kernel is valinna 4.4.19, there's no cgroup_nov1 option, and I thi=
nk the only
> possibility is cgroup_disable=3Dcpu kernel option.
>
>> Regards,
>> Rami Rosen
>>
>>
>> -----Original Message-----
>> From: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:cgroups-owner-u79uwXL29TaqPxH82wqD4g@public.gmane.org=
g] On Behalf Of Sverd Johnsen
>> Sent: Friday, September 02, 2016 12:13
>> To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Why would cpu cgroup get disabled by the kernel?
>>
>> Hi! I'am on 4.4.19 (arm)  and seem to have all requirements for CPU cgro=
ups build into the kernel:
>>
>>  # zgrep -P "CGROUP|GROUP|FAIR" /proc/config.gz CONFIG_CGROUPS=3Dy # CON=
FIG_CGROUP_DEBUG is not set # CONFIG_CGROUP_FREEZER is not set CONFIG_CGROU=
P_PIDS=3Dy CONFIG_CGROUP_DEVICE=3Dy CONFIG_CGROUP_CPUACCT=3Dy # CONFIG_CGRO=
UP_PERF is not set CONFIG_CGROUP_SCHED=3Dy CONFIG_FAIR_GROUP_SCHED=3Dy CONF=
IG_RT_GROUP_SCHED=3Dy CONFIG_BLK_CGROUP=3Dy # CONFIG_DEBUG_BLK_CGROUP is no=
t set # CONFIG_SCHED_AUTOGROUP is not set CONFIG_CFQ_GROUP_IOSCHED=3Dy # CO=
NFIG_NET_CLS_CGROUP is not set # CONFIG_CGROUP_NET_PRIO is not set # CONFIG=
_CGROUP_NET_CLASSID is not set # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is n=
ot set # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
>>
>> Other cgroups also work:
>>
>> # findmnt -a
>> TARGET                       SOURCE
>> FSTYPE     OPTIONS
>> |-/sys                       sysfs
>> sysfs      rw,nosuid,nodev,noexec,relatime
>> | |-/sys/kernel/security     securityfs
>> securityfs rw,nosuid,nodev,noexec,relatime
>> | |-/sys/fs/cgroup           tmpfs
>> tmpfs      ro,nosuid,nodev,noexec,mode=3D755
>> | | |-/sys/fs/cgroup/systemd cgroup
>> cgroup     rw,nosuid,nodev,noexec,relatime,xattr,release_agent=3D/usr/li=
b/systemd/systemd-cgroups-agent,name=3Dsystemd
>> | | |-/sys/fs/cgroup/devices cgroup
>> cgroup     rw,nosuid,nodev,noexec,relatime,devices
>> | | |-/sys/fs/cgroup/blkio   cgroup
>> cgroup     rw,nosuid,nodev,noexec,relatime,blkio
>> | | |-/sys/fs/cgroup/pids    cgroup
>> cgroup     rw,nosuid,nodev,noexec,relatime,pids
>> | | `-/sys/fs/cgroup/cpuacct cgroup
>> cgroup     rw,nosuid,nodev,noexec,relatime,cpuacct
>>
>> However I get this:
>>
>> # dmesg | egrep "cgroup|control group"
>> [    0.000000] Initializing cgroup subsys cpu
>> [    0.000000] Initializing cgroup subsys cpuacct
>> [    0.001242] Disabling cpu control group subsystem
>> [    0.001263] Initializing cgroup subsys io
>> [    0.001289] Initializing cgroup subsys devices
>> [    0.001304] Initializing cgroup subsys pids
>>
>> # column -t /proc/cgroups
>> #subsys_name  hierarchy  num_cgroups  enabled
>> cpu           0          1            0
>> cpuacct       5          59           1
>> blkio         3          9            1
>> devices       2          56           1
>> pids          4          64           1
>>
>> Why? really weird. I control the boot process (systemd 231) and nothing =
there apparently disables it. When I try to mount cpu cgroup manually I jus=
t get ENOENT
>> --
>> To unsubscribe from this list: send the line "unsubscribe cgroups" in th=
e body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  ht=
tp://vger.kernel.org/majordomo-info.html
>>  =EF=BF=BD=EF=BF=BD=EC=B9=BB =EF=BF=BD&=EF=BF=BD~=EF=BF=BD&=EF=BF=BD =EF=
=BF=BD=EF=BF=BD+-=EF=BF=BD=EF=BF=BD=DD=B6 =EF=BF=BD=EF=BF=BDw=EF=BF=BD=EF=
=BF=BD=CB=9B=EF=BF=BD=EF=BF=BD=EF=BF=BDm=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD)=EF=BF=BD=EF=BF=BD=EF=BF=BDw* jg=EF=BF=BD=EF=BF=BD=EF=BF=BD =
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DD=A2j/=EF=BF=BD=EF=BF=BD=EF=
=BF=BDz=EF=BF=BD=DE=96=EF=BF=BD=EF=BF=BD2=EF=BF=BD=DE=99=EF=BF=BD=EF=BF=BD=
=EF=BF=BD&=EF=BF=BD)=DF=A1=EF=BF=BDa=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD =
=EF=BF=BDG=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD =EF=BF=BDj:+v=EF=BF=BD=EF=
=BF=BD=EF=BF=BDw=EF=BF=BD=D9=A5
>>
>
