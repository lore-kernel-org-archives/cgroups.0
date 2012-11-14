From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 05/17] cgroup: cgroup->dentry isn't a RCU pointer
Date: Wed, 14 Nov 2012 10:55:04 -0800
Message-ID: <20121114185504.GG21185@mtj.dyndns.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
	<1352775704-9023-6-git-send-email-tj@kernel.org>
	<50A37B0A.7010608@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=BuMScMWLEWTdqySBE9As4VF+gVDAjZN21lfZJNQTrCA=;
	b=P7MhrahJ8EXf/3o7yO0o7FAkD+E7F/FAVOrSVnxfPQRNC4ZU/aOsefvnZhMTQ46ME/
	wVb3kf1XJ9JYCszKo6FFwCySC5Ut9bOrsmZHCQJG5D1kQLJrwh619GRSiUt26NEjY/wh
	1j9EkX+8KKilzLkyNLkYe7eLJcDq2q5UF5EYBYtEe13KelqScVB6+EY52nd8tRK4eaHC
	rkMOaB8A4YjHEUBjMQ4mGIBmIVO1J+PplsYZmTkaapS0D3itWoT5bOZGHb4wKFz6pE8u
	K0D/z7V/B1bPispuLHCFZtgyiZEt04pst9bgi+EEZpC54i17qAUGYQHibydBgKFaPe3N
	kcSQ==
Content-Disposition: inline
In-Reply-To: <50A37B0A.7010608-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
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
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Glauber.

On Wed, Nov 14, 2012 at 03:05:46PM +0400, Glauber Costa wrote:
> Will memcontrol.c need similar amendments?
> 
> The code that lives in -mm and includes kmemcg includes the following
> excerpt:
> 
>         rcu_read_lock();
>         dentry = rcu_dereference(memcg->css.cgroup->dentry);
>         rcu_read_unlock();

Ooh, yeah, hmmm... that should happen after this series gets merged.
I'll mark it as pending.

Thanks.

-- 
tejun
