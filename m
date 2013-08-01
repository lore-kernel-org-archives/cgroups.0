From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/7] cgroup: remove struct cgroup_seqfile_state
Date: Thu, 1 Aug 2013 09:11:02 +0800
Message-ID: <51F9B5A6.4050905@huawei.com>
References: <51F8C7C5.9040608@huawei.com> <51F8C829.3040708@huawei.com> <51F8D88B.2040400@huawei.com> <20130731113557.GK2810@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130731113557.GK2810-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/7/31 19:35, Tejun Heo wrote:
> On Wed, Jul 31, 2013 at 05:27:39PM +0800, Li Zefan wrote:
>>>  static int cgroup_seqfile_release(struct inode *inode, struct file *file)
>>>  {
>>> -	struct seq_file *seq = file->private_data;
>>> -	kfree(seq->private);
>>>  	return single_release(inode, file);
>>>  }
>>
>> Oh, I just realized now we can remove cgroup_seqfile_release().
>>
>> Will send out an updated patch...
> 
> Applied the updated patch.  Can you please post updated patches as
> replies to the original path from next time?  That makes things easier
> to track on my side.
> 

Sure.
