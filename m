From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch v4] Soft limit rework
Date: Tue, 4 Jun 2013 20:08:59 +0200
Message-ID: <20130604180859.GB9321@dhcp22.suse.cz>
References: <1370254735-13012-1-git-send-email-mhocko@suse.cz>
 <CAKTCnz=CMbhhROPV4iC6_XPuu_8J53ZMTdXtY_bevPjG+B-+mw@mail.gmail.com>
 <20130604163828.GA9321@dhcp22.suse.cz>
 <CAKTCnz=MP5iadPJkngJqGMnXSwe9n-xGDEdzuT5Aqoyx0KAYwA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Jqgj7A81BgR5sREOkZHkjkEeWagrdopZGHyTw80CI9M=;
        b=vum1lnQL7Lh/5eI04tuNH/eoX5xk0Ik1KiYii9LMtIMYFHLorPCBpggteQwmwhF/ry
         lJMqacfelVLyLo3VCXhFE4upUV9VuqYznOMCAN6qE5tXNWkLZ0KaKwYpMSKPVBe8QwMs
         3sv2hx5akfMzR31K4b99uoMxVbi+TBe32Uw0+VOtNxSAlJewxTMgMaGNdd5PFEevmWWH
         p8ylJ0qInB1ack8TxmxlrVSvhrQG7QaEjKWvAchD8VSt0k3w35QY+Q+af+QLw85lzPX3
         iJQdCI6nMa+9No+cbDhD7ypO9YKetsIcC/tL/bLP/oiDnyzXmfyshYtHzBFm2/w4nvnK
         qlbA==
Content-Disposition: inline
In-Reply-To: <CAKTCnz=MP5iadPJkngJqGMnXSwe9n-xGDEdzuT5Aqoyx0KAYwA@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Balbir Singh <bsingharora@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>, Glauber Costa <glommer@parallels.com>, Michel Lespinasse <walken@google.com>, Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>

On Tue 04-06-13 23:27:05, Balbir Singh wrote:
> > OK, let me summarize. The primary intention is to get rid of the current
> > soft reclaim infrastructure which basically bypasses the standard
> > reclaim and tight it directly into shrink_zone code. This also means
> > that the soft reclaim doesn't reclaim at priority 0 and that it is
> > active also for the targeted (aka limit) reclaim.
> >
> > Does this help?
> >
> 
> Yes. What are the limitations of no-priority 0 reclaim?

I am not sure I understand the question. What do you mean by
limitations?

The priority-0 scan was always a crude hack. With a lot of pages in on
the LRU it might cause huge big stalls during direct reclaim. There are
workloads which benefited from such an aggressive reclaim - e.g.
streaming IO but that doesn't justify this kind of reclaim.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
