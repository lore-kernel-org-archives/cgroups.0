From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Is not locking task_lock in cgroup_fork() safe?
Date: Mon, 8 Oct 2012 11:01:38 +0900
Message-ID: <20121008020138.GA4188@localhost>
References: <20121008020000.GB2575@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=AYU6c3Tvm+9Xezg5X1RrIfgEgspZGHaSFzlXcH1HoNA=;
	b=s5ITFX6Zgasf5MxIGajsZ6laCgnrAS5+gmtwj/T7yuqOrAmhV8B0qpTwG0LUiiaSr5
	G6Ex+b+yKJX+qh39cipo7mH55cqSYhgzwcCpi+onBoDIuUmCk/lV90NRLzE+LTVNIfyG
	X6LIDqFCWhnhqCtfo+fWNphj7/1aYIeG5hSqh+DWRS+AshR1Z/B7JvZciNPBR5NRsiad
	gCIkYMBGVJ/xYA2b0Cg9gTWzQJoeBHgOZslkvPwnVFUGg69OUur6Y9FNWa7BcAq0NGIY
	M5fO5gnb262o3ph25N5fk+2aelGpU99Mnpcw/OjSJd/afsSkw2RxXei/zdFDJVkgk3lg
	bwSA==
Content-Disposition: inline
In-Reply-To: <20121008020000.GB2575@localhost>
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
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Oct 08, 2012 at 11:00:00AM +0900, Tejun Heo wrote:
> 7e381b0eb1 ("cgroup: Drop task_lock(parent) on cgroup_fork()") removed
> task_lock from cgroup_fork citing that current->cgroups can't change
> due to threadgroup_change locking; however, threadgroup_change locking
> is used only during CLONE_THREAD forking.  If @current is forking a
> new process, there's nothing preventing someone else to migrate the
> parent while forking is in progress and delete the css_set it
> currently is using.  Am I confused somewhere?

Also, please note that task_lock is likely to be hot on local CPU at
that point and avoiding it there might not really buy much.

Thanks.

-- 
tejun
