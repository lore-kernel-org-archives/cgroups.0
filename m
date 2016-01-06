From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv1 6/6] rdmacg: Added documentation for rdma controller.
Date: Thu, 7 Jan 2016 05:22:40 +0530
Message-ID: <CAG53R5XKpP6YAe8buRrgG=m4_dQK5MjkWtcA7CN-74AJ1SUUyQ@mail.gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
	<1452020286-9508-7-git-send-email-pandit.parav@gmail.com>
	<20160105215309.GG5995@mtj.duckdns.org>
	<CAG53R5WD18VK3sVuVnPR7yjEBqRjHAoUkCpZKzSd9-PYZrx-YA@mail.gmail.com>
	<20160106225714.GI3660@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=/YOC2Ar2ftAO+y3tRtstUbiDyXSX8AYjpv62Y+1wmRc=;
        b=faY9RBWpeGLJPt16o1eHhHz9wRlaP0m5R7CVirGudm/uawyaXXfcw/za0vR6YmtjB0
         rTFGg1dM6DbGwBshJdfcQnVGImzaKC3tbqKUn7fzIK8A7CAoWTCu+gctaYRFU1dAQTxG
         W+kvCDwTQeweziSCKkHWwHBYmQn6ZpSxG0kJRkf6LRLSKi7dji2+S7993gFWsbVIB8kh
         aDPZK20Qy2IfJ1tnacRUnZRTY2f3k5a/ltoIyYudUxnig9FIpLcu83mMWiH/FsjQJqJy
         ukLl5IOktngITGAfUuBroU7o8A924i3u+nnnaD67DnaEcq1XGovi+dQB0UFESrpgUjQu
         ezzA==
In-Reply-To: <20160106225714.GI3660-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jan 7, 2016 at 4:27 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Thu, Jan 07, 2016 at 04:14:26AM +0530, Parav Pandit wrote:
>> Yes. I read through. I can see two changes to be made in V2 version of
>> this patch.
>> 1. rdma.resource.verb.usage and rdma.resource.verb.limit to change
>> respectively to,
>> 2. rdma.resource.verb.stat and rdma.resource.verb.max.
>> 3. rdma.resource.verb.failcnt indicate failure events, which I think
>> should go to events.
>
> What's up with the ".resource" part?

I can remove "resource" key word. If just that if something other than
resource comes up to limit to in future, it will be hard to define at
that time.

> Also can't the .max file list
> the available resources?  Why does it need a separtae list file?
>
max file does lists them only after limits are configured for that
device. Thats when rpool (array of max and usage counts) is allocated.

If user wants to know what all knobs are available, than list file
exposes them on per device basis without actually mentioning actual
limit or without allocating rpool arrays.

If you are hinting that I should allocate rpool array when rdma cgroup
is created, that can be done for already discovered devices.
If new devices are discovered after cgroup is created, for them we
anyway have to allocate/free when they appear/disappear.

In different implementation, where list of all the rdma cgroups can be
maintained, and rpool arrays can be allocated for all of them when new
device appear/disappear. This can move complexity of dynamic
allocation from try_charge/uncharge to device addition and removal
APIs. ib_register_ib_device() level.
However this comes with memory cost, where even if those device doesnt
participate in cgroup, for them rpool memory will be allocated for
each such rdma cgroup.

list file looks like below for two device entries.
mlx4_0 ah qp mr pd srq flow
ocrdma0 ah qp mr pd

max file looks like below.
mlx4_0 ah=100 qp=40 mr=10 pd=90 srq=10 flow=10


>> I roll out new patch for events post this patch as additional feature
>> and remove this feature in V2.
>>
>> rdma.resource.verb.list file is unique to rdma cgroup, so I believe
>> this is fine.
>
> Please see above.
>
>> We will conclude whether to have rdma.resource.hw.<files> or not in
>> other patches.
>> I am in opinion to keep "resource" and "verb" or "hw" tags around to
>> keep it verbose enough to know what are we trying to control.
>
> What does that achieve?  I feel that it's getting overengineered
> constantly.

Please see above for "resource". I guess we are not loosing anything
by having "rdma.resource" vs just having "rdma".
But if that sounds too much, we can remove "resource".

>
> Thanks.
>
> --
> tejun
