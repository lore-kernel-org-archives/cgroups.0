From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup: consolidate cgroup_attach_task() and
 cgroup_attach_proc()
Date: Tue, 19 Mar 2013 14:32:15 -0700
Message-ID: <20130319213215.GP3042@htj.dyndns.org>
References: <513FD395.7000906@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=EVBn8c0uZevZ0FuenIhk91EIj7mdlKGj+MX/Jqkjchs=;
        b=TsPBuyPXBgjAhQIy1eWH/P0i1yR48isNHnDwmUKFpjcASS8W7Z6LcvsquQkv8Bs85y
         mX2GRWiaz4794xkXKz/SUkt+y/awIF7G9jroZWaGAbvH+5SwC8TLs4+Ixwx6BRyPGcii
         gtRd7S+M+tgLJLhG8q5sPMBb0Khs/fdko4GaPuO4hOfM0LppmNUvFtiwOV/XTY4Js8Jv
         hXCjwdFlswZMZKn3tsanZrZD3Ni+ox1QcI8ubuTD+GZeTgwGtMAuT4av1BMlxnTJneHL
         kjcqK9aXeGAX5zCM18gVvZ1F2XTk7e9tH+1+xuQOSCd2O/AceKaTOgyEQht0jcA7PmG5
         riKg==
Content-Disposition: inline
In-Reply-To: <513FD395.7000906@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Wed, Mar 13, 2013 at 09:17:09AM +0800, Li Zefan wrote:
> These two functions share most of the code.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun
