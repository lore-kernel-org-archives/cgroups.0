From: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Thu, 21 Nov 2013 16:59:47 +0100
Message-ID: <CA+SBX_OeGCr5oDbF0n7jSLu-TTY9xpqc=LYp_=18qFYHB-nBdg@mail.gmail.com>
References: <5278B3F1.9040502@huawei.com>
	<20131107235301.GB1092@cmpxchg.org>
	<20131108001437.GC1092@cmpxchg.org>
	<CA+SBX_P6wzmb0k0qM1m06C_1024ZTfYZOs0axLBBJm46X+osqA@mail.gmail.com>
	<20131111153943.GA22384@dhcp22.suse.cz>
	<CA+SBX_PiRoL7HU-C_wXHjHYduYrbTjO3i6_OoHOJ_Mq+sMZStg@mail.gmail.com>
	<20131112135844.GA6049@dhcp22.suse.cz>
	<CA+SBX_O4oK1H7Gtb5OFYSn_W3Gz+d-YqF7OmM3mOrRTp6x3pvw@mail.gmail.com>
	<20131118094554.GA32623@dhcp22.suse.cz>
	<CA+SBX_PqdsG5LBQ1uLpPsSUsbjF8TJ+ok4E+Hp_3AdHf+_5e-A@mail.gmail.com>
	<20131118191655.GB12923@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=oBFT+GrB2yrLiA6bn5kZ7FRGXscQpKGmSo8SCjfmjAE=;
        b=Lm3pNWg9s+D0u9Cc5We6IzrmAzqN11RocofBwVW5y/xywnUmuGTADeAA3HHqckgMj0
         pMF30Gq901eLI0WhkNIMT6x3sJs8rbh/BWwhRZ0WXU3tOnZJA9H9iPA0FGmmvUB1QcGJ
         UQdydGZRHqejf9qYqUd1tgdQmeSb/Allugcqg58FTpstWyfg5KWYeuYvPT6LJ9GmEVO9
         UQ+duBjbQSBREsksyb+u0hw7TY2bQeAv3z2kVV+stsoh574f2XifOU4uwT1h7aKZ9lmV
         b7ltTLq1nSTt94p7GSjWWiFRpHWv7c1vj6AMQFpePcARhkTp1Mn0HrlJoD/UVSHhGh4X
         bjgA==
In-Reply-To: <20131118191655.GB12923-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> Add more debugging information I guess. Let's see if something like the
> following helps

This is the trace from your patch. I tested without any additional
patches this time.

    kworker/3:4-6865  [003] ....   326.253052: mem_cgroup_css_offline:
memcg:ffffc9001e5ff000 is going offline now
     kworker/3:4-6865  [003] ....   326.267446:
mem_cgroup_css_offline: memcg:ffffc9001e5ff000 is offline now
    kworker/10:1-414   [010] ....   326.562382:
mem_cgroup_css_offline: memcg:ffffc9001e603000 is going offline now
    kworker/10:1-414   [010] ....   326.568337:
mem_cgroup_css_offline: memcg:ffffc9001e603000 is offline now
    kworker/9:10-7239  [009] ....   326.568365:
mem_cgroup_css_offline: memcg:ffffc9001e60b000 is going offline now
    kworker/9:10-7239  [009] ....   326.574326:
mem_cgroup_css_offline: memcg:ffffc9001e60b000 is offline now
     kworker/3:4-6865  [003] ....   326.635898:
mem_cgroup_css_offline: memcg:ffffc9001e58f000 is going offline now
     kworker/3:4-6865  [003] ....   326.643935:
mem_cgroup_css_offline: memcg:ffffc9001e58f000 is offline now
     kworker/3:5-6867  [003] ....   326.643946:
mem_cgroup_css_offline: memcg:ffffc9001e58b000 is going offline now
     kworker/3:5-6867  [003] ....   326.659264:
mem_cgroup_css_offline: memcg:ffffc9001e58b000 is offline now
    kworker/10:0-161   [010] ....   326.723844:
mem_cgroup_css_offline: memcg:ffffc9001e597000 is going offline now
    kworker/10:0-161   [010] ....   326.728909:
mem_cgroup_css_offline: memcg:ffffc9001e597000 is offline now
    kworker/10:1-414   [010] ....   326.728922:
mem_cgroup_css_offline: memcg:ffffc9001e593000 is going offline now
    kworker/10:1-414   [010] ....   326.738232:
mem_cgroup_css_offline: memcg:ffffc9001e593000 is offline now
    kworker/10:3-7203  [010] ....   326.738244:
mem_cgroup_css_offline: memcg:ffffc9001e59f000 is going offline now
    kworker/10:3-7203  [010] ....   326.743857:
mem_cgroup_css_offline: memcg:ffffc9001e59f000 is offline now
    kworker/10:2-3071  [010] ....   326.743893:
mem_cgroup_css_offline: memcg:ffffc9001e59b000 is going offline now
    kworker/10:2-3071  [010] ....   326.753218:
mem_cgroup_css_offline: memcg:ffffc9001e59b000 is offline now
    kworker/9:11-7240  [009] ....   326.753246:
mem_cgroup_css_offline: memcg:ffffc9001e5a7000 is going offline now
    kworker/9:11-7240  [009] ....   326.755855:
mem_cgroup_css_offline: memcg:ffffc9001e5a7000 is offline now
    kworker/9:12-7241  [009] ....   326.755866:
mem_cgroup_css_offline: memcg:ffffc9001e5a3000 is going offline now
    kworker/9:12-7241  [009] ....   326.762211:
mem_cgroup_css_offline: memcg:ffffc9001e5a3000 is offline now
     kworker/0:4-7314  [000] ....   328.775898:
mem_cgroup_css_offline: memcg:ffffc9001e613000 is going offline now
     kworker/0:4-7314  [000] ....   328.784328:
mem_cgroup_css_offline: memcg:ffffc9001e613000 is offline now
     kworker/0:1-200   [000] ....   328.920820:
mem_cgroup_css_offline: memcg:ffffc9001e5b7000 is going offline now
     kworker/0:1-200   [000] ....   328.928921:
mem_cgroup_css_offline: memcg:ffffc9001e5b7000 is offline now
     kworker/0:4-7314  [000] ....   328.928929:
mem_cgroup_css_offline: memcg:ffffc9001e5b3000 is going offline now
     kworker/0:4-7314  [000] ....   328.941245:
mem_cgroup_css_offline: memcg:ffffc9001e5b3000 is offline now
     kworker/3:5-6867  [003] ....   339.851929:
mem_cgroup_css_offline: memcg:ffffc9001e67d000 is going offline now
     kworker/3:5-6867  [003] ....   339.863333:
mem_cgroup_css_offline: memcg:ffffc9001e67d000 is offline now
     kworker/4:1-201   [004] ....   340.228760:
mem_cgroup_css_offline: memcg:ffffc9001e675000 is going offline now
     kworker/4:1-201   [004] ....   340.238803:
mem_cgroup_css_offline: memcg:ffffc9001e675000 is offline now
     kworker/4:6-7253  [004] ....   340.238812:
mem_cgroup_css_offline: memcg:ffffc9001e671000 is going offline now
     kworker/4:6-7253  [004] ....   340.251156:
mem_cgroup_css_offline: memcg:ffffc9001e671000 is offline now
     kworker/8:5-7224  [008] ....   340.262765:
mem_cgroup_css_offline: memcg:ffffc9001e689000 is going offline now
     kworker/8:5-7224  [008] ....   340.272181:
mem_cgroup_css_offline: memcg:ffffc9001e689000 is offline now
     kworker/8:7-7232  [008] ....   340.505639:
mem_cgroup_css_offline: memcg:ffffc9001e66d000 is going offline now
     kworker/8:7-7232  [008] ....   340.521665:
mem_cgroup_css_offline: memcg:ffffc9001e66d000 is offline now
     kworker/8:5-7224  [008] ....   340.521673:
mem_cgroup_css_offline: memcg:ffffc9001e669000 is going offline now
     kworker/8:5-7224  [008] ....   340.536024:
mem_cgroup_css_offline: memcg:ffffc9001e669000 is offline now
    kworker/9:12-7241  [009] ....   354.575345:
mem_cgroup_css_offline: memcg:ffffc9001e623000 is going offline now
    kworker/9:12-7241  [009] ....   354.582758:
mem_cgroup_css_offline: memcg:ffffc9001e623000 is offline now
    kworker/9:10-7239  [009] ....   354.582808:
mem_cgroup_css_offline: memcg:ffffc9001e5d7000 is going offline now
    kworker/9:10-7239  [009] ....   354.594402:
mem_cgroup_css_offline: memcg:ffffc9001e5d7000 is offline now
    kworker/9:13-7242  [009] ....   354.594411:
mem_cgroup_css_offline: memcg:ffffc9001e5d3000 is going offline now
    kworker/9:13-7242  [009] ....   354.609388:
mem_cgroup_css_offline: memcg:ffffc9001e5d3000 is offline now
     kworker/8:7-7232  [008] ....   354.610288:
mem_cgroup_css_offline: memcg:ffffc9001e5f7000 is going offline now
     kworker/8:7-7232  [008] ....   354.633525:
mem_cgroup_css_offline: memcg:ffffc9001e5f7000 is offline now
##### CPU 11 buffer started ####
   kworker/11:11-7257  [011] ....   395.484996:
mem_cgroup_reparent_charges: memcg:ffffc9001e5c3000 u:393216 k:0
tasks:0
   kworker/11:11-7257  [011] ....   395.487995:
mem_cgroup_reparent_charges: memcg:ffffc9001e5c3000 u:393216 k:0
tasks:0
   kworker/11:11-7257  [011] ....   395.490991:
mem_cgroup_reparent_charges: memcg:ffffc9001e5c3000 u:393216 k:0
tasks:0
   kworker/11:11-7257  [011] ....   395.493988:
mem_cgroup_reparent_charges: memcg:ffffc9001e5c3000 u:393216 k:0
tasks:0
   kworker/11:11-7257  [011] ....   395.496991:
mem_cgroup_reparent_charges: memcg:ffffc9001e5c3000 u:393216 k:0
tasks:0
< ... >
