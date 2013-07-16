From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH V4 5/6] memcg: patch mem_cgroup_{begin,end}_update_page_stat()
 out if only root memcg exists
Date: Tue, 16 Jul 2013 12:26:38 +0800
Message-ID: <CAFj3OHX5cRZTyi-xXJHGOrkE8CbnJ0KFkEfB3FUuOr7bk+fWWQ@mail.gmail.com>
References: <1373044710-27371-1-git-send-email-handai.szj@taobao.com>
	<1373045623-27712-1-git-send-email-handai.szj@taobao.com>
	<20130711145625.GK21667@dhcp22.suse.cz>
	<CAHH2K0avjz=H8k2zo-P-QJt=9f61GoAmq+ceECzGNxdUx1PWbA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=M/+Y24HNBtz7JbqfvdAV1gn5nThlzr7CJKNQMgqC1Vw=;
        b=EmRzfwVbT9+s7aBbp0BdZfhPFtXiSojuUlDAk+FQAfnAO/Co4bg6fyzUCD+EsD6iut
         iaZW1bBo+kov4lSogD7Zoaph5Cs1JXDRLK2hSLSlJa1w/lkJQYRTSREp7/SAIzQb2Ye6
         EjSAeOk8wc1qVYnxBi00XMndh+KQAGKnkguhYLGcwy6TKDRrUn51P/HPBNXDiVXgxovH
         hTpjV7URq80SMfw6oQT9mW+dCw4VxdCKLGlP2EIXHcgtiRRKOTpwha+vlO33GbY8r1H/
         LbkFb11EzPpfbAoeocQ4hANHv8GA/oBUoQQz7MX0xpTe6Uh3KvA7iSGGnE/DdqbVEHBN
         gmMA==
In-Reply-To: <CAHH2K0avjz=H8k2zo-P-QJt=9f61GoAmq+ceECzGNxdUx1PWbA@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>, Mel Gorman <mgorman@suse.de>, Sha Zhengju <handai.szj@taobao.com>

On Tue, Jul 16, 2013 at 1:58 AM, Greg Thelen <gthelen@google.com> wrote:
> On Thu, Jul 11, 2013 at 7:56 AM, Michal Hocko <mhocko@suse.cz> wrote:
>> On Sat 06-07-13 01:33:43, Sha Zhengju wrote:
>>> From: Sha Zhengju <handai.szj@taobao.com>
>>>
>>> If memcg is enabled and no non-root memcg exists, all allocated
>>> pages belongs to root_mem_cgroup and wil go through root memcg
>>> statistics routines.  So in order to reduce overheads after adding
>>> memcg dirty/writeback accounting in hot paths, we use jump label to
>>> patch mem_cgroup_{begin,end}_update_page_stat() in or out when not
>>> used.
>>
>> I do not think this is enough. How much do you save? One atomic read.
>> This doesn't seem like a killer.
>
> Given we're already using mem_cgroup_{begin,end}_update_page_stat(),
> this optimization seems independent of memcg dirty/writeback
> accounting.  Does this patch help memcg even before dirty/writeback
> accounting?  If yes, then we have the option of splitting this
> optimization out of the series.

Set_page_dirty is a hot path, people said I should be careful to the
overhead of adding a new counting, and the optimization is a must
before merging.
But since we have more need of this feature now, if it's blocking
something, I'm willing to split it.

--
Thanks,
Sha

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
