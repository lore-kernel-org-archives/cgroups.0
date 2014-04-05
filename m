From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT PULL] cgroup changes for v3.15-rc1
Date: Fri, 4 Apr 2014 18:06:54 -0700
Message-ID: <CA+55aFyGz2q4iDEt56Bw+x_ri_-DQYLAKPJvk3Uxj9z-y+0uPw@mail.gmail.com>
References: <20140403164911.GE24119@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=mime-version:sender:in-reply-to:references:date:message-id:subject
	:from:to:cc:content-type;
	bh=FmGVKPVrs3qF+aSQbmb/8vZ4aR5jH8MnqIVbzHW2q28=;
	b=fAY0W7mN5DQcRp9YTGt0UaK5jR0N1TY4S8/zj/9b0mOnyqN7MtoYTk65wWtTsUKXkG
	mABoyhGbEytYT5so5ZkJAPjpFbEO4hcVVqTvsdDiW6G2Gp2ElITzsSZUIjfDxvWHhzhe
	CKOTXXKi2htLMcZ2alkn2B2Iz8wkiGEkkuZ/Z2KYqU+Jqr+X7/KtU8LfJ/+NSIwyAVq+
	gevgE891KzIKycCxo+w60aUdOGi1bCeqT2E/U/8J4zqzn/aq+lRsHTS/VhUg+0YjkYSS
	kK4kujzFxuL8f2MvQp5vnddb4UGRVjf1EnRI6uGlUR9ZoTjP5WZF3NqcFtoo+HEaQfaZ
	1yRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=google;
	h=mime-version:sender:in-reply-to:references:date:message-id:subject
	:from:to:cc:content-type;
	bh=FmGVKPVrs3qF+aSQbmb/8vZ4aR5jH8MnqIVbzHW2q28=;
	b=Gh5l5Gt8ULxlp1pqaIZlVKOr9JQweb6q4ERsttY+G2khLNrJ2/G13HfgB6tGy+K9ms
	6TaLJ2FgWQ45QJSjeYCB/vlV3+Z+MUtWVFawROyFVf3NrhHUF2UVVpX18uW0QZVEmara
	HYFB/Tw6IKLL1nvcPROrLQ6uo+ZfHTjm50YpQ=
In-Reply-To: <20140403164911.GE24119-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
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
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Apr 3, 2014 at 9:49 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> A lot updates for cgroup [...]

Btw, just a heads up to let you know: I'm in the middle of bisecting
why my machine no longer reboots cleanly, and while I'm a few boots
away from pinpointing it exactly, it has now drilled down to the point
that the only remaining commits are from your cgroup pull that I
pulled yesterday.

Maybe I screwed something up in the bisection and it's not 100%
reliable, but I don't think so.

Will report back soon when I've narrowed it down more.

               Linus
