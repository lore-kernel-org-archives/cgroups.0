From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/7] cpuset: remove async hotplug propagation work
Date: Sun, 9 Jun 2013 08:47:57 -0700
Message-ID: <20130609154757.GC2835@htj.dyndns.org>
References: <51B4475A.8030509@huawei.com>
 <51B44787.2030601@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=sjv+loOfoLi8bpJH7DhCnG8xI+AJe1mpZa0fKTsbxeI=;
	b=J26poS23mjJF/sqq/SqmDIeFnf8uNzUEehgkGe7nsFrRLN5jI6XdF1CxCYLcEtJ82X
	l5AJ4HkKpuE2VZYuMQ6TZu4GPJlfZimUJlvBlvFHESnZxlJh3si6l3OLDUINlBCrjoMZ
	IY8I+cCAAI0FK7noGO4H3/rZxb4ZuuhBbewy65shCZ5gTgOHwwwkFdkSHdN/wB45RUyG
	8VAwI0G0GpKRkYWr3OvEz/BL8WV/O11KL99OiLFojupfjz3vm6CizdIhOJJODfu/n7R7
	E6KGw5QFpUpTEGADsEWW1yD9c6RZONQMznaHaGPpz5FoIa1X0Q9cVHSDOTCEHSBbjf5V
	e+ZA==
Content-Disposition: inline
In-Reply-To: <51B44787.2030601-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun, Jun 09, 2013 at 05:14:47PM +0800, Li Zefan wrote:
> As we can drop rcu read lock while iterating cgroup hierarchy,
> we don't have to do propagation asynchronously via workqueue.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied 1-2 to cgroup/for-3.11-cpuset.  Thanks!

-- 
tejun
