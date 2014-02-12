From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/5] cgroup: update cgroup_transfer_tasks() to either
	succeed or fail
Date: Wed, 12 Feb 2014 10:30:33 -0500
Message-ID: <20140212153033.GA26809@htj.dyndns.org>
References: <1392063694-26465-1-git-send-email-tj@kernel.org>
	<1392063694-26465-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=CcKKzEOgK3m020hsjEcdcCNul+dXAmbw/FenllKXrzQ=;
	b=wLCISgL7cTqgGBPTkUA+oKCcVa7cZVrLlQnJU9Pv/XootfYMhrDrZ5kGVNgY3WnvXi
	6CAvil6dKr2Bq86G4p4VX+BCQ/07Cp7EDVXOR5dZpS6HFLsxCFzPrXvhqgwjb8/HcvsE
	qQGpdzJu29HNTS1spHMXL4f44QCm/QavzvsbkAEnZcWag3a2vq5gu9YyMCjQUjnxupLF
	n3SIsf3iT2vYk/BABaIvlAnYn+pP0Qu7xKtXgqHQbrKg8R6BFXRf+xkoANuHhVj2cgKg
	27sdKEiPSqntgwWGjlRS+dGU8p3Vx4fsu1Jsx1xjnPFuiKwhyJ8GHD3O6AGWmhEHPvWf
	3sjQ==
Content-Disposition: inline
In-Reply-To: <1392063694-26465-6-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Feb 10, 2014 at 03:21:34PM -0500, Tejun Heo wrote:
> cgroup_transfer_tasks() can currently fail in the middle due to memory
> allocation failure.  When that happens, the function just aborts and
> returns error code and there's no way to tell how many actually got
> migrated at the point of failure and or to revert the partial
> migration.
> 
> Update it to use cgroup_migrate{_add_src|prepare_dst|migrate|finish}()
> so that the function either succeeds or fails as a whole as long as
> ->can_attach() doesn't fail.

While this solves one aspect of the problem, it may still race with
fork and may leave newly forked tasks behind.  I'll think more about
it.

Thanks.

-- 
tejun
