From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: simplify cgroup removal path
Date: Wed, 31 Oct 2012 10:18:49 -0700
Message-ID: <20121031171849.GH2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
	<50912C6D.6020000@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=rVv/mV7MmEM1fmUkAHHp+CO5mcoM9yJBFRMIa1FJP5w=;
	b=tlGpJbHihDq/SfevD10dmgGdgr02PIO48SkVKHylncEgblchAg79lkqdYF64eqBrjz
	yTJc+Z0ccr+7djoLEjdqqB/Xk3n39zVKBCmFfMvXew9VreP4n2eF+tvg0qLR/jdPlcBl
	s2csRJ6aZ6uwB8dDojcScTqYFRRZMJbk7y96d//fKSYcoP3Iqt7y7CebVpGtxGkxkdDV
	R8m4B3xGIsgvMSpKdJCGK8E4lReAt5EF5HFw4RHRbxNNWXEnc2nSDJpAobfspwE0YGOm
	+Qy7CpDCjUovuseiy8T/KYPTJH7x597Kc1jw+czBy+Bh+13IMNoL0EhFrLkHUbunYccY
	jiTQ==
Content-Disposition: inline
In-Reply-To: <50912C6D.6020000-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
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
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello,

On Wed, Oct 31, 2012 at 05:49:33PM +0400, Glauber Costa wrote:
> The only think that drew my attention is that you are changing the
> local_irq_save callsite to local_irq_disable. It shouldn't be a problem,
> since this is never expected to be called in interrupt context.
> 
> Still... it makes me wonder if that disabled-interrupt block is still
> needed? According to the changelogs, it was introduced in e7c5ec919 for
> the css_tryget mechanism. But css_tryget itself will never scan
> subsystems, so if we can no longer fail, we should be able to just ditch
> it. Unless I am missing something

Note both in the commit messages.

Thanks.

-- 
tejun
