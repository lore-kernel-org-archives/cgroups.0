From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v3 05/28] memcg: Reclaim when more than one page
 needed.
Date: Tue, 29 May 2012 09:20:16 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205290919130.4666@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290917230.4666@router.home>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1338301220; bh=POrGWsNtQ+EDBByg9ETUKEdsva/ctNBOi32IqQW9O/M=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=oMii0Rv+aNTG3gBkiynso+KzR3bECc5xoyK7kOKp09v0P7nJaRpaooRjxdyoqrxI3LNWWRMfZacKigyARLEGn+RS9vzbGnHV0GjRexf6DQWIR/66PDHL4hriFT/ttdSwzUkqmw0rLLjBf1HvQMWqTWyFTSXs2uh1BIir2vQ3Wio=
In-Reply-To: <alpine.DEB.2.00.1205290917230.4666@router.home>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, David Rientjes <rientjes@google.com>

On Tue, 29 May 2012, Christoph Lameter wrote:

> >  	 * unlikely to succeed so close to the limit, and we fall back
> >  	 * to regular pages anyway in case of failure.
> >  	 */
> > -	if (nr_pages == 1 && ret)
> > +	if (nr_pages <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER) && ret) {

Should this not be

	 nr_pages <= 1 << PAGE_ALLOC_COSTLY_ORDER

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
