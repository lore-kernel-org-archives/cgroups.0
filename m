From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch -v4 4/8] memcg: enhance memcg iterator to support
 predicates
Date: Wed, 5 Jun 2013 02:09:38 -0700
Message-ID: <20130605090938.GA8266@mtj.dyndns.org>
References: <20130604010737.GF29989@mtj.dyndns.org>
 <20130604134523.GH31242@dhcp22.suse.cz>
 <20130604193619.GA14916@htj.dyndns.org>
 <20130604204807.GA13231@dhcp22.suse.cz>
 <20130604205426.GI14916@htj.dyndns.org>
 <20130605073728.GC15997@dhcp22.suse.cz>
 <20130605080545.GF7303@mtj.dyndns.org>
 <20130605085239.GF15997@dhcp22.suse.cz>
 <20130605085849.GB7990@mtj.dyndns.org>
 <20130605090739.GH15997@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=14WYN/zpyr1SKnhCAcZIsk/nPp28Ue/qSxxX8s5fVWU=;
        b=gaRJH5FRkSFU2Ox+Wrmhs/l2M6qzDZCnQYkjNJEy2KofgxUHADB2zbdRBj0WeCrSnv
         GSua4G31a5sIgblxO981GP0LFqF9pJ2x1SwL02xiD+KDg5D+/ou+H5tDr9t9ty5utFGA
         fX7icmi0/5Bf5/NVd5mrPc+oYPcIDQtEq2fzVMBUhjLUcX6vZTL38q7MAaalA1nFKLLQ
         Li9NPBHjO88dWIAKGCjjGcQyoPIjQJim+tlsQW9415rULCwYrY5NQAIbieh8TkspHYHQ
         ZB/Xrc5bH6tyBQiOQ+wNxYtJZ6PTHxSRRmpEglMCeXE2jGpnrNHkVjKutClMmOveo82t
         RIQg==
Content-Disposition: inline
In-Reply-To: <20130605090739.GH15997@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>, Glauber Costa <glommer@parallels.com>, Michel Lespinasse <walken@google.com>, Greg Thelen <gthelen@google.com>, Balbir Singh <bsingharora@gmail.com>

On Wed, Jun 05, 2013 at 11:07:39AM +0200, Michal Hocko wrote:
> On Wed 05-06-13 01:58:49, Tejun Heo wrote:
> [...]
> > Anyways, so you aren't gonna try the skipping thing?
> 
> As I said. I do not consider this a priority for the said reasons (i
> will not repeat them).

That's a weird way to respond.  Alright, whatever, let me give it a
shot then.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
