From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/8] cgroup: kill CSS_REMOVED
Date: Wed, 31 Oct 2012 10:10:44 -0700
Message-ID: <CAOS58YP=CjTPFdETLRXnc3gXEzX2=EEe2dMdSh3Eov7zRfV4Qg@mail.gmail.com>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
	<1351657365-25055-3-git-send-email-tj@kernel.org>
	<20121031153926.GC22809@dhcp22.suse.cz>
	<20121031165739.GE2945@htj.dyndns.org>
	<50915A87.4070504@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=mime-version:sender:in-reply-to:references:date
	:x-google-sender-auth:message-id:subject:from:to:cc:content-type;
	bh=xwMS956PA6TGnBhny07YvxqJVsV1/V+xycIdJVmtQIQ=;
	b=lFGj7fr2lg8XZoRrjqBL1gF4RCKSaSFygs98hsVOqx4VUMtq5wZaEfhRv3lEaUe6rs
	xOKtbQOdfJf93Q1dLN1iz/wgKyPJwD10uUQMy6QONpLPtisWzdVxKG58csoCpt3NXxX+
	zjxYV/01xVVXYkGDQhw/O/Po7RtKDvusT8w9dqb8rPIAxXTcFTf7w6H8+Ghe+fKZ81jC
	gObNHl/5tHFjNuh+TKCshTjGO/uc6X8KNSMK12tLZC6ZtyOH8R1Ogs0VWneTJ9r3tnad
	RZCDHsdRZX1eqBgMzJYwzaYg8Axg1hSM7FRQq2VV/LbDIDaZWwfZ9fQEYCXKZwIjLxJd
	mczA==
In-Reply-To: <50915A87.4070504-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
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
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello, Glauber.

On Wed, Oct 31, 2012 at 10:06 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> This is not the topic of this thread, but since you brought it:
> If you take a look at the description patch in the patch I sent, the
> problem I outlined is that at create time, we don't know anything about
> which will the css_id be - and I would like to avoid creating yet
> another index.
>
> Is there any way you would suggest of handling this ? Any chance of us
> allocating the css_id earlier then?

I only glanced the patch description but the problem I'm trying to
solve is locking - currently we don't have a place where a controller
can tell a cgroup is becoming online; thus it has nothing to
synchronized against and tell that a cgroup is alive or not.  As for
css_id allocation, maybe you can deal with that in ->post_create() or
maybe we can allocate css_id earlier (but where would it be stored?).
I'll look into it.

Thanks.

-- 
tejun
