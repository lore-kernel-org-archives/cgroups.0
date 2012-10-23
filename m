From: Michal Hocko <mhocko@suse.cz>
Subject: Re: process hangs on do_exit when oom happens
Date: Tue, 23 Oct 2012 10:35:58 +0200
Message-ID: <20121023083556.GB15397@dhcp22.suse.cz>
References: <op.wmbi5kbrn27o5l@gaoqiang-d1.corp.qihoo.net>
 <20121019160425.GA10175@dhcp22.suse.cz>
 <CAKWKT+ZRMHzgCLJ1quGnw-_T1b9OboYKnQdRc2_Z=rdU_PFVtw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <CAKWKT+ZRMHzgCLJ1quGnw-_T1b9OboYKnQdRc2_Z=rdU_PFVtw@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qiang Gao <gaoqiangscut@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, linux-mm@kvack.org, bsingharora@gmail.com

On Tue 23-10-12 11:35:52, Qiang Gao wrote:
> I'm sure this is a global-oom,not cgroup-oom. [the dmesg output in the end]

Yes this is the global oom killer because:
> cglimit -M 700M ./tt 
> then after global-oom,the process hangs..

> 179184 pages RAM

So you have ~700M of RAM so the memcg limit is basically pointless as it
cannot be reached...
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
