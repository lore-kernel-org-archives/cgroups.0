From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup cgroup]
Date: Fri, 29 Jun 2012 10:20:11 +0800
Message-ID: <4FED10DB.7040500@huawei.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com> <20120627182903.GP15811@google.com> <4FEBF4B7.2070105@huawei.com> <20120628180712.GC22641@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120628180712.GC22641-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 2012/6/29 2:07, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:

> Hello, Li.
> 
> On Thu, Jun 28, 2012 at 02:07:51PM +0800, Li Zefan wrote:
>>> Hmm... fa980ca87d "cgroup: superblock can't be released with active
>>> dentries" is supposed to have fixed that.  Looking into it.
>>>
>>
>>
>> I think I know what happened here:
>>
>> umount
>>   deativate_super(sb)
>>                        dput(subdir)
>>                          subdir->d_count--
>>                          d_release(subdir)
>>                            deactivate_super(sb)
>>                              shrink_dcache_for_umount(sb)
>>                                BUG(root->d_count)!!
>>                          root->d_count--
> 
> Can you please elaborate a bit?  I'm not really following?  Where does
> the last root->d_count-- come from?
> 


From my limited knowledge about vfs internal, seems the parent's refcnt won't go down
to 0 before its children. When mkdir, the parent's refcnt will be incremented, and
after rmdir, dput(subdir) will drop subdir's refcnt and then drop parent's.

So when dropping the subdir's refcnt and leading the superblock to be killed, the root's
dentry is still > 0.

>> I use this script to reproduce the bug:
>>
>> mount -t cgroup -o cpu xxx /mnt
>> mkdir /mnt/sub
>> sleep 100 < /mnt/sub &
>> kill $!
>> wait $!
>> rmdir /mnt/sub
>> umount /mnt
> 
> Unfortunately, this doesn't reproduce the bug here either. :(
> 


I can reproduce the bug reliably.. Try s/cpu/perf or s/cpu/net_cls, which have fewer
cgroup files?
