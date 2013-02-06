From: "azurIt" <azurit@pobox.sk>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_from_add=5Fto=5Fpage=5Fcache=5Flocked?=
Date: Wed, 06 Feb 2013 02:17:21 +0100
Message-ID: <20130206021721.1AE9E3C7@pobox.sk>
References: <20121218152223.6912832C@pobox.sk>, <20121218152004.GA25208@dhcp22.suse.cz>, <20121224142526.020165D3@pobox.sk>, <20121228162209.GA1455@dhcp22.suse.cz>, <20121230020947.AA002F34@pobox.sk>, <20121230110815.GA12940@dhcp22.suse.cz>, <20130125160723.FAE73567@pobox.sk>, <20130125163130.GF4721@dhcp22.suse.cz>, <20130205134937.GA22804@dhcp22.suse.cz>, <20130205154947.CD6411E2@pobox.sk> <20130205160934.GB22804@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130205160934.GB22804@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>, =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>

>5-memcg-fix-1.patch is not complete. It doesn't contain the folloup I
>mentioned in a follow up email. Here is the full patch:


Here is the log where OOM, again, killed MySQL server [search for "(mysql=
d)"]:
http://www.watchdog.sk/lkml/oom_mysqld6

azur

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
