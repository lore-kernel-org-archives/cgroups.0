From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/7] cgroup: mount cgroupns-root when inside non-init
	cgroupns
Date: Wed, 9 Dec 2015 10:48:27 -0500
Message-ID: <20151209154827.GI30240@mtj.duckdns.org>
References: <1449529582-4075-1-git-send-email-serge.hallyn@ubuntu.com>
	<1449529582-4075-6-git-send-email-serge.hallyn@ubuntu.com>
	<20151208162040.GC30240@mtj.duckdns.org>
	<20151208232124.GA17234@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=lxBFAS6pa/SGJlH9FcCMMaAq7FNQFrIY6Gz698O/MB4=;
	b=NS87dxw661bObanrWTAxsGvFegH0BLba3A3fjDgnqIRrcUur3lzbm9rFUdJaukLyg5
	rvkO330JGmciUXxbmH8PjYloLpFhdbSW8zwhIbrbjxmcHdvIIpyR4wErzXlvoVCKZTtn
	g7aDXISpzIZhBfcRvR1xWQ4vZhaR5oMPx5aN+yzqgjR1+AgJVqa3CtDOqEb39/RkqhF6
	N4NUcLekCKT3keykkQB1mlpqrTq6oRHPOP9brMlhvqWJ2L3RU8BCgerJ1ZZAonMwjMrJ
	3COAyow8DhZulX3oZHkSp0N0kjSTKPgqi1NXdr328vQSV36IP7wbcOy8LZes76JeYqIt
	kukQ==
Content-Disposition: inline
In-Reply-To: <20151208232124.GA17234-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
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
To: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hello, Serge.

On Tue, Dec 08, 2015 at 05:21:24PM -0600, Serge E. Hallyn wrote:
> > Heh, is kernfs_obtain_root() the right name?  Maybe
> > kernfs_node_to_inode()?
> 
> kernfs_node_to_dentry?
> 
> This would presumably make the question of whether to pass in a namespace
> moot?

Sounds good.

Thanks.

-- 
tejun
