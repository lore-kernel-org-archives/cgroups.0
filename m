From: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Mon, 4 Nov 2013 14:43:41 +0100
Message-ID: <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
References: <4431690.ZqnBIdaGMg@akheu22.uni-muenster.de>
	<5257F7CE.90702@huawei.com>
	<CA+SBX_Pa8sJbRq3aOghzqam5tDUbs_SPnVTaewtg-pRmvUqSzA@mail.gmail.com>
	<5258E584.70500@huawei.com>
	<CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w@mail.gmail.com>
	<525CB337.8050105@huawei.com>
	<CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ@mail.gmail.com>
	<CA+SBX_OJBbYzrNX5Mi4rmM2SANShXMmAvuPGczAyBdx8F2hBDQ@mail.gmail.com>
	<5270BFE7.4000602@huawei.com>
	<alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
	<20131031130647.0ff6f2c7@gandalf.local.home>
	<alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
	<20131031192732.2dbb14b3@gandalf.local.home>
	<CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
	<5277932C.40400@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=J36DeWORsHEgyTg6YBigGtOPHJbvc79BiJQUZsQdfBg=;
        b=DY5E5hLietoP4j/PwvDFPSTbhcqRG4F0i83G54xvYOROiHZVJhaSKH9fAuqHcb1PkD
         RWUUAF2qEMLpVceznEMIUZsfyUsq1TNvY/QXJ+HMqummBWoasCBkiJLNrt2mU6pZhyPA
         SvdQ5k9i2e2i9XnFRZ0ABZvTENLgMQxVrZQBemKePZFz9rdHE+/qiDuTp/GvBTyMsqze
         dcLXCInKHl8p4kEth83oe+30lWnhlzt980UjiEH7HTSvsKaDbDZ9cYRtjH3iTuu5JBmx
         C7cT+h+/NRARjtS8e72HDBMt7vkTC9YetX3jNyV2hjTkEwKO5VdemJlwMfcxSNoiMzIp
         FOkA==
In-Reply-To: <5277932C.40400-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> synchronize_rcu() is a block operation and can keep us waiting for
> a long period, so instead it's possible that usage never goes down
> to 0 and we are in a dead loop.

Ok, I didn't think of that. Tracing shows that the function keeps
looping. The last lines repeat indefinitely.

     kworker/2:0-6747  [002] ....   926.354954:
mem_cgroup_reparent_charges: usage: 0
     kworker/4:1-542   [004] ....   926.366555:
mem_cgroup_reparent_charges: usage: 0
##### CPU 6 buffer started ####
     kworker/6:1-2553  [006] ....   926.377376:
mem_cgroup_reparent_charges: usage: 0
##### CPU 0 buffer started ####
     kworker/0:4-7306  [000] ....   926.399285:
mem_cgroup_reparent_charges: usage: 0
     kworker/0:6-7308  [000] ....   926.411155:
mem_cgroup_reparent_charges: usage: 0
     kworker/0:7-7309  [000] ....   926.420248:
mem_cgroup_reparent_charges: usage: 0
     kworker/6:2-7304  [006] ....   926.432144:
mem_cgroup_reparent_charges: usage: 0
##### CPU 7 buffer started ####
     kworker/7:2-7303  [007] ....   926.438061:
mem_cgroup_reparent_charges: usage: 0
     kworker/2:2-2813  [002] ....   926.451030:
mem_cgroup_reparent_charges: usage: 0
     kworker/0:8-7310  [000] ....   926.466091:
mem_cgroup_reparent_charges: usage: 0
     kworker/7:0-240   [007] ....   926.478073:
mem_cgroup_reparent_charges: usage: 0
     kworker/4:0-225   [004] ....   926.485006:
mem_cgroup_reparent_charges: usage: 0
     kworker/2:3-7311  [002] ....   926.497057:
mem_cgroup_reparent_charges: usage: 0
##### CPU 1 buffer started ####
     kworker/1:3-7313  [001] ....   926.502987:
mem_cgroup_reparent_charges: usage: 0
     kworker/4:3-7315  [004] ....   926.509086:
mem_cgroup_reparent_charges: usage: 0
     kworker/1:4-7317  [001] ....   926.518786:
mem_cgroup_reparent_charges: usage: 0
     kworker/2:4-7316  [002] ....   926.524988:
mem_cgroup_reparent_charges: usage: 0
     kworker/2:5-7320  [002] ....   926.538006:
mem_cgroup_reparent_charges: usage: 0
##### CPU 34 buffer started ####
    kworker/34:1-1453  [034] ....   926.569158:
mem_cgroup_reparent_charges: usage: 0
##### CPU 3 buffer started ####
     kworker/3:5-7605  [003] ....   987.403711:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.406709:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.409708:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.412706:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.415705:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.418703:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.424688:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.427700:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.430698:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.433697:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.436696:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.439694:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.442693:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.445692:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.448691:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.451689:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.454688:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.457686:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.460685:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.463684:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.469668:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.472680:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.475678:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.478677:
mem_cgroup_reparent_charges: usage: 1568768
     kworker/3:5-7605  [003] ....   987.481675:
mem_cgroup_reparent_charges: usage: 1568768
