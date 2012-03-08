From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: revise the position of threshold index while
 unregistering event
Date: Thu, 8 Mar 2012 16:30:28 +0900
Message-ID: <20120308163028.df8b6bde.kamezawa.hiroyu@jp.fujitsu.com>
References: <1331035943-7456-1-git-send-email-handai.szj@taobao.com>
	<20120308144448.889337cf.kamezawa.hiroyu@jp.fujitsu.com>
	<4F58599A.3090100@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4F58599A.3090100@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, kirill@shutemov.name, Sha Zhengju <handai.szj@taobao.com>

On Thu, 08 Mar 2012 15:02:50 +0800
Sha Zhengju <handai.szj@gmail.com> wrote:

> On 03/08/2012 01:44 PM, KAMEZAWA Hiroyuki wrote:
> > On Tue,  6 Mar 2012 20:12:23 +0800
> > Sha Zhengju<handai.szj@gmail.com>  wrote:
> >
> >> From: Sha Zhengju<handai.szj@taobao.com>
> >>
> >> Index current_threshold should point to threshold just below or equal to usage.
> >> See below:
> >> http://www.spinics.net/lists/cgroups/msg00844.html
> >>
> >>
> >> Signed-off-by: Sha Zhengju<handai.szj@taobao.com>
> > Thank you for resending.
> >
> > Acked-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> >
> It's not a resending, though they are for the same reason.  May be I should
> merge them together ...
> 
Ah. Hmm..If your previous patch isn't picked up yet, could you send it again 
(or merge and post merged one ) ?

Thanks,
-Kame


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
