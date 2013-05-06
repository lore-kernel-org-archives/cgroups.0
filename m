From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 29.5/32] blk-throttle: add throtl_qnode for dispatch
	fairness
Date: Mon, 6 May 2013 11:35:03 -0700
Message-ID: <20130506183503.GA32173@mtj.dyndns.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
	<20130504005044.GF22860@mtj.dyndns.org>
	<20130506160006.GA11731@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:date:from:to:cc:subject:message-id:references
	:mime-version:content-type:content-disposition:in-reply-to
	:user-agent; bh=pHep2IecPTjUjNiSVN3yyviLckTfEdE3RtzRswPyYiA=;
	b=uzLWWSwxjHKhmKUk/i9aLqCJJQIJmsRpl2Gb7SPBjNBkNLHUty28SasFAYgBrxZXGs
	+WEV/7vq0RkHMmRpMtPKw0WzmOW0a32QeQmAHO8Ma3MA/H98Eikaenfppr2T35W+uvqD
	h20nN8RAZPi39Dg9bHjoqkRHRGraSmPBrA0MXH4ggVhN9DD0p03Hq74FWoTpOY+1SGxE
	+85EgQzjeL9kSkXB14Vrv6YznWrBEPvPscFWvgfyC3oFBRi2iDV7zZ+z2UBas0JNvcg3
	mp0att/VgUs+THR40CQi17Ahluqhspp7Ex5rGA1BrXFAvqHkqOyHfBlCJax3C+L4lcUz
	ekMw==
Content-Disposition: inline
In-Reply-To: <20130506160006.GA11731-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, May 06, 2013 at 12:00:06PM -0400, Vivek Goyal wrote:
> On Fri, May 03, 2013 at 05:50:44PM -0700, Tejun Heo wrote:
> 
> [..]
> > +	 * qnode_on_self is used when bios are directly queued to this
> > +	 * throtl_grp so that local bios compete fairly with bios
> > +	 * dispatched from children.  qnode_on_parent is used when bios are
> > +	 * dispatched from this throtl_grp into its parent and will compete
> > +	 * with the sibling qnode_on_parents and the parent's
> > +	 * qnode_on_self.
> > +	 */
> > +	struct throtl_qnode qnode_on_self;
> > +	struct throtl_qnode qnode_on_parent;
> 
> Do we need one throtl_qnode for each IO dir (read/write) so that we can
> queue up the right direction throtl_node in right sq->queued[rw].

Yes, we do.  Thanks for spotting it.  Will post an updated version soon.

-- 
tejun
