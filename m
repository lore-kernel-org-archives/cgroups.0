From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Re: WARN in __mark_inode_dirty when mounting a filesystem
Date: Fri, 11 Dec 2015 12:26:24 +0200
Message-ID: <566AA4D0.9060202@kyup.com>
References: <56533374.2090807@kyup.com>
 <20151123212130.GE19072@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151123212130.GE19072-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>



On 11/23/2015 11:21 PM, Tejun Heo wrote:
> Hello,
> 
> On Mon, Nov 23, 2015 at 05:40:36PM +0200, Nikolay Borisov wrote:
>> Hello Tejun, 
>>
>> On one of my servers I recently hit the following warn: 
>>
>> 182317.101584] ------------[ cut here ]------------
>> [182317.101753] WARNING: CPU: 7 PID: 13192 at fs/fs-writeback.c:2080 __mark_inode_dirty+0x20a/0x350()
>> [182317.102032] bdi-block not registered
>> [182317.102192] Kernel panic - not syncing: panic_on_warn set ...
>>                 
>> [182317.102474] CPU: 7 PID: 13192 Comm: mount Not tainted 4.2.5-vanilla1 #1
> 
> Is the problem reproducible?  If so, can you please see whether the
> following patch makes any difference?
> 
>  http://lkml.kernel.org/g/1448054554-24138-1-git-send-email-idryomov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Tested-by: Nikolay Borisov (kernel-6AxghH7DbtA@public.gmane.org)


> 
> Thanks.
> 
