From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 20/24] block: RCU free request_queue
Date: Wed, 2 Jan 2013 15:43:55 -0500
Message-ID: <20130102204355.GF11220@mtj.dyndns.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
	<1356726946-26037-21-git-send-email-tj@kernel.org>
	<20130102184814.GD4306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:date:from:to:cc:subject:message-id:references
	:mime-version:content-type:content-disposition:in-reply-to
	:user-agent; bh=eDNGbujCYFk8H7eZFoK8MslHbS/cgX9MVS4nrUX7VQk=;
	b=oq45fw/C+AgJafEAz6SG1tsz5PUs1H0E5JERNI5JiX45rGolS8/8qGS0dcBVFWuXcM
	FKmsdr/FjyPCOX2InzKZpczOjoKirksH1UY0dAqci4RfMK1CUV3yiUMjBR3g78DPnFeF
	Bg8w+n+yayxMIJuBIb4AmcOl0cLCXp51Yf+1rCZpm1uekrZAQU6qIJ+g8RdD/8r2lKhQ
	u3MIURMM0X+Yg4ymnWLvSr3RZKC5tvjMwO9LxlrWD80/gzmFxRu9W/5Szac9rp49QGHf
	18DTzFyiSsFY4KwTMSf8nNRjwGlb57iTwnD+rq+fjgyhlzOWdZIRTfzo05b1u8VjDAvW
	bfzw==
Content-Disposition: inline
In-Reply-To: <20130102184814.GD4306-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 02, 2013 at 01:48:15PM -0500, Vivek Goyal wrote:
> On Fri, Dec 28, 2012 at 12:35:42PM -0800, Tejun Heo wrote:
> > RCU free request_queue so that blkcg_gq->q can be dereferenced under
> > RCU lock.  This will be used to implement hierarchical stats.
> 
> Can we just take a blkg reference on ->q in blkg_alloc() and drop that
> reference in blkg_free(), instead of RCU freeing up queue.

I don't think we can invoke blk_release_queue() from RCU free contxt,
so we can't put request_queue from blkg_rcu_free().  Maybe we can go
through a work item but that's uglier.

Thanks.

-- 
tejun
