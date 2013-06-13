From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/11] cgroup: use kzalloc() and list_del_init()
Date: Wed, 12 Jun 2013 19:52:02 -0700
Message-ID: <20130613025202.GD10979@localhost>
References: <1371070996-20613-1-git-send-email-tj@kernel.org>
	<1371070996-20613-5-git-send-email-tj@kernel.org>
	<51B93038.9010202@huawei.com> <20130613023831.GB10979@localhost>
	<CAOS58YPv_uKeTqZSNF=sXTEnLn=LTbsdpBPM5K_ykXoVT-+CpA@mail.gmail.com>
	<20130613024310.GC10979@localhost>
	<20130613024859.GA7432@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20120113;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=OYTQbr68j90RlhxaX14c3j5tIS9sI2ujSFxemQbP6Ag=;
	b=Gi+im9iy3Lex6cYi8kJhS4cJvf+hD2ZgN2WiuQrqwR/J36BojqxvM14I+g1v7l60uN
	8T+wDa6BurrQHd4j+pBjQNtyfPMqbl0DXpb6JqxFf0TZGNDEa+Yc2jXLC+6ydcRoDFpg
	P0on9h1vBqf6t1oReJX2cPVKU1LjDnBBLHa90FKUFFcEUPawSDbEZV2JW+OAp4BjvKR4
	lOrMeVMd2pYi7GpxY8Tdq7E3myPUfG9CkdPR66tXXOA8gkAO/9cZaQKGw4MvPnFetDht
	b2qazwOwJap1k95EUXzAtZ4HxTDb+skMCKO9fla4PA63fTH2lF1BXML6rneUYXLFeyHx
	LwhQ==
Content-Disposition: inline
In-Reply-To: <20130613024859.GA7432-9pTldWuhBndy/B6EtB590w@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jun 12, 2013 at 07:48:59PM -0700, Tejun Heo wrote:
> On Wed, Jun 12, 2013 at 07:43:10PM -0700, Kent Overstreet wrote:
> > list_del() does do poisoning - and list debugging is cheaper to enable
> > than full slab debugging.
> 
> Ah, right, now we have DEBUG_LIST.  Completely forgot about that.  I
> don't think the cost difference matters that much as long as there are
> enough people running with slab debugging, but, yeah, with DEBUG_LIST,
> leaving list_del() alone would actually be better.  I'll drop that
> part.

I can't remember if it was Fedora or RH (or both?) but in one of those
they actually leave it enabled in their production kernels. Someone was
blogging about the bugs it found...
