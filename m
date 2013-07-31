From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 5/7] cgroup: remove struct cgroup_seqfile_state
Date: Wed, 31 Jul 2013 17:27:39 +0800
Message-ID: <51F8D88B.2040400@huawei.com>
References: <51F8C7C5.9040608@huawei.com> <51F8C829.3040708@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51F8C829.3040708@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

>  static int cgroup_seqfile_release(struct inode *inode, struct file *file)
>  {
> -	struct seq_file *seq = file->private_data;
> -	kfree(seq->private);
>  	return single_release(inode, file);
>  }

Oh, I just realized now we can remove cgroup_seqfile_release().

Will send out an updated patch...
