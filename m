From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Add a file named cgroup.procs_stat in cgroup
Date: Fri, 4 May 2018 10:31:47 -0700
Message-ID: <20180504173147.GA4649@kroah.com>
References: <1525444100-4858-1-git-send-email-qiangzh.hust@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1525455119;
        bh=vy0CuwD8sipzvV54xrvvSpjrL6xzSvgQOi6iqAyhhvQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vM5Bx/ZkI7umRiPZ9QEI6wzgCL4dP6QblaUp0Dodpa0rOrNFO9s9WILgPH8KdN/Fd
         IsYShblena8B67r+GbXDiZrHC+XWgype7TlUXmXPDQWt3ZqFZ3CBqjxl8x47zcEAzP
         BYjnmmPrTw0Ap+aD4uzqe+27RSfO9yNYEpeY9dY0=
Content-Disposition: inline
In-Reply-To: <1525444100-4858-1-git-send-email-qiangzh.hust@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: zhangq95 <qiangzh.hust@gmail.com>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, peterz@infradead.org, cgroups@vger.kernel.org, riel@redhat.com, gs051095@gmail.com, akpm@linux-foundation.org, oleg@redhat.com, tglx@linutronix.de, keescook@chromium.org, longman@redhat.com, prsood@codeaurora.org, guro@fb.com, davem@davemloft.net, mhocko@suse.com, kirill.shutemov@linux.intel.com, marcos.souza.org@gmail.com, hoeun.ryu@gmail.com, rostedt@goodmis.org, bigeasy@linutronix.de, alexander.levin@verizon.com, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com

On Fri, May 04, 2018 at 10:28:20PM +0800, zhangq95 wrote:
> When I run "cat /proc/stat" in a container, container will access
> host's file directly which is a security risk.

Why is this a "security risk"?  What can be learned there that is
somehow "bad"?

thanks,

greg k-h
