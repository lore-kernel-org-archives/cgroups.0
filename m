From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/5] cgroup: update iterators to use cgroup_next_sibling()
Date: Wed, 22 May 2013 18:17:42 +0900
Message-ID: <20130522091742.GA3466@mtj.dyndns.org>
References: <1369101025-28335-1-git-send-email-tj@kernel.org>
	<1369101025-28335-5-git-send-email-tj@kernel.org>
	<519C8B2E.5040606@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=Z+qNTqDDX0uBawmnvQsimhErs1nk1zA+MLQdZU6yz7g=;
	b=ZY8flTtghKsPI/QHyoZeMn8kXwz6lBB/+lxsuj1EJkis+rakKPU6R1Ax0mn3toZK7V
	2cQ6VQWy6lkX6x1qohF4zdozl71WyzBaHO7lzAx6twJQYQP4MM5MsB2OK74zZDd5YR9v
	E7Amz865SjVRF6MDuKqnKYSFugpxCxdd4FarT/y8TDdia6aUnnfsSlI8g8yaCxFlariJ
	ASA/oZvfD5HNojA9sk3aeNbatyTOTsEglxVa7cErwkR2iZhdXZ8Q+bpP7FTXk0BnZM+T
	5PZLHRPssoCFUta1W37IldNQk6x3PUWcZYX93HjI8v7nrwW+xo3hxFk3bqfPvn9SyLyK
	ZTsA==
Content-Disposition: inline
In-Reply-To: <519C8B2E.5040606-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 22, 2013 at 05:09:02PM +0800, Li Zefan wrote:
> > @@ -3068,6 +3071,11 @@ EXPORT_SYMBOL_GPL(cgroup_next_descendant_pre);
> >   * Return the rightmost descendant of @pos.  If there's no descendant,
> >   * @pos is returned.  This can be used during pre-order traversal to skip
> >   * subtree of @pos.
> > + *
> > + * While this function requires RCU read locking, it doesn't require the
> > + * whole traversal to be contained in a single RCU critical section.  This
> > + * function will return the correct rightmost descendant as long as @pos is
> > + * accessible.
> >   */
> >  struct cgroup *cgroup_rightmost_descendant(struct cgroup *pos)
> >  {
> 
> Forgot to convert cgroup_rightmost_descendat() to use cgroup_next_sibling()?
> 
>         do {
>                 last = pos;
>                 /* ->prev isn't RCU safe, walk ->next till the end */
>                 pos = NULL;
>                 list_for_each_entry_rcu(tmp, &last->children, sibling)
>                         pos = tmp;
>         } while (pos);

It's always walking from the parent->children with RCU read locked, so
it doesn't need to be converted.  We can still convert it for
consistency and I had that in the patch originally but dropped it as
the conversion seemed a bit misleading as it covers a case which can
never happen.  Hmmm....

Thanks.

-- 
tejun
