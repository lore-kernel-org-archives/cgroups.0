From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs_path_from_node_locked: don't overwrite nlen
Date: Wed, 20 Apr 2016 15:43:13 -0400
Message-ID: <20160420194313.GA4775@htj.duckdns.org>
References: <1460923472-29370-1-git-send-email-serge.hallyn@ubuntu.com>
	<1460923472-29370-2-git-send-email-serge.hallyn@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to:user-agent;
	bh=qVE90jj/ehDgqw4eqgLWY5BRS6fP8DS3UclJj2EHAeQ=;
	b=go0z0uQwR8wStAYoLimlQSxLtde0fyM2SXuaFI+moe3JueEzpJcJQcyGBp9jtDNxTT
	7GJZ8KoEcGa5V6WtZVSdMOEItc1o+3B5DRyVXVTI6LiQASclJFx5WAL90E45Y5HbleBI
	7km+F+Teb+M4GqVMC+bfxiL99VW9oKYjtaJuhRVN12Fxk7eYHZYW4I6QV+EqpeJu8Rpw
	mfG872yoO2572bGeu3fRi4ln1WC6Fe9Pzn4Eiaqa6TlEPm0yty8QxaGCkYVLsU2d7cC1
	31S5fjq7Az3bc25KLBJb4W6F38zaYMNP31Ijg8NFWhlvhZuiRA4Vq0S3ArOdKFBNAqaS
	ZvEA==
Content-Disposition: inline
In-Reply-To: <1460923472-29370-2-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
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
To: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Sun, Apr 17, 2016 at 03:04:31PM -0500, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org wrote:
> From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> 
> We've calculated @len to be the bytes we need for '/..' entries from
> @kn_from to the common ancestor, and calculated @nlen to be the extra
> bytes we need to get from the common ancestor to @kn_to.  We use them
> as such at the end.  But in the loop copying the actual entries, we
> overwrite @nlen.  Use a temporary variable for that instead.
> 
> Without this, the return length, when the buffer is large enough, is
> wrong.  (When the buffer is NULL or too small, the returned value is
> correct. The buffer contents are also correct.)
> 
> Interestingly, no callers of this function are affected by this as of
> yet.  However the upcoming cgroup_show_path() will be.
> 
> Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Greg, can you please pick this one up for v4.6?

Thanks.

-- 
tejun
