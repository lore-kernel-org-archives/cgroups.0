From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol.c: Remove duplicate inclusion of sock.h
 file
Date: Fri, 14 Sep 2012 11:56:53 +0200
Message-ID: <20120914095653.GD28039@dhcp22.suse.cz>
References: <1347350934-17712-1-git-send-email-sachin.kamat@linaro.org>
 <20120911095200.GB8058@dhcp22.suse.cz>
 <20120912072520.GB17516@dhcp22.suse.cz>
 <50504CE1.8030509@parallels.com>
 <20120912125647.GH21579@dhcp22.suse.cz>
 <20120912130935.GJ21579@dhcp22.suse.cz>
 <CAK9yfHwMnC65BvY3RG7duf_Cmt5hf1VLV=vZRag4Mm6nHdQ-GA@mail.gmail.com>
 <20120914082741.GC28039@dhcp22.suse.cz>
 <5052EBAD.6060202@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5052EBAD.6060202-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Sachin Kamat <sachin.kamat-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Fri 14-09-12 12:32:45, Glauber Costa wrote:
> On 09/14/2012 12:27 PM, Michal Hocko wrote:
> > On Fri 14-09-12 13:28:07, Sachin Kamat wrote:
> >> Hi Michal,
> >>
> >> Has this patch been accepted?
> > 
> > Not yet. I am waiting for Glauber to ack it.
> > 
> 
> I am fine with the change, assuming you tested it, after you made the
> change I requested.

OK, I will repost the patch.
-- 
Michal Hocko
SUSE Labs
