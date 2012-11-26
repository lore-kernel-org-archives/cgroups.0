From: "azurIt" <azurit@pobox.sk>
Subject: =?utf-8?q?Re=3A_memory=2Dcgroup_bug?=
Date: Mon, 26 Nov 2012 01:38:55 +0100
Message-ID: <20121126013855.AF118F5E@pobox.sk>
References: <20121121200207.01068046@pobox.sk>, <20121122152441.GA9609@dhcp22.suse.cz>, <20121122190526.390C7A28@pobox.sk>, <20121122214249.GA20319@dhcp22.suse.cz>, <20121122233434.3D5E35E6@pobox.sk>, <20121123074023.GA24698@dhcp22.suse.cz>, <20121123102137.10D6D653@pobox.sk>, <20121123100438.GF24698@dhcp22.suse.cz>, <20121125011047.7477BB5E@pobox.sk>, <20121125120524.GB10623@dhcp22.suse.cz> <20121125135542.GE10623@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20121125135542.GE10623@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>

>This is hackish but it should help you in this case. Kamezawa, what do
>you think about that? Should we generalize this and prepare something
>like mem_cgroup_cache_charge_locked which would add __GFP_NORETRY
>automatically and use the function whenever we are in a locked context?
>To be honest I do not like this very much but nothing more sensible
>(without touching non-memcg paths) comes to my mind.


I installed kernel with this patch, will report back if problem occurs ag=
ain OR in few weeks if everything will be ok. Thank you!

Btw, will this patch be backported to 3.2?

azur

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
