From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/10] cgroup: convert memcg controller to the new cftype
	interface
Date: Tue, 20 Mar 2012 22:08:49 -0700
Message-ID: <CAOS58YOwtmOG5tDuMtFCw=sHV-aeU-Ok+KXzR81Aix+OZqMpUA@mail.gmail.com>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
	<1331940963-15756-7-git-send-email-tj@kernel.org>
	<4F66B55A.8020307@jp.fujitsu.com>
	<20120319161052.GC11069@google.com>
	<4F695C3F.3000406@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=mime-version:sender:in-reply-to:references:date
	:x-google-sender-auth:message-id:subject:from:to:cc:content-type;
	bh=S6Ygg5cGFC9TLJNvCqbelXOaLJC9ouQr7sqJ9cO4CII=;
	b=xiEl1ewW55m/DMF4Z3WBPwOKlOJW80rgRjwZK+RXxbvJ/4kvP7xkp0LD3umnLwkmjD
	PVo7GBanNp3UAaDtutGOgFTN/HYgd/LM1XPFldsL8f6dDwpei4h3ClYiODBts7mUZ/rC
	nPucXinWBN/N7ZyUHa0XJQhSuw1Ti5ho+vK7CqFed8Lw8R9BwoKXtX3xR7+5zHmYtb8S
	+QI6UP7Dx0bWN6MujvcJZ+6aVAIa1IwpiUTY6lH+EBA72lQMi9+f2/o1vOdFVhftphLz
	qyaOcdJSHE2YfyY0yldgJTUmoByR7cPmiQn/hnk7jcCL+fUgBJ8y6WO9aDezb/K4sBAE
	4p5g==
In-Reply-To: <4F695C3F.3000406-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
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
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Mar 20, 2012 at 9:42 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> I think creating file based on really_do_swap_account is wrong.
> (I'm sorry for this complication.)
>
> How about creating this file unconditionally ? Returning -ENOTSUP in memcg's
> handler will work well...anyway it's configured, no reason to show them is bad.

That works for me. Then, I can also remove the _COND thing which isn't
pretty anyway. I'll update the patchset.

Thanks.

-- 
tejun
