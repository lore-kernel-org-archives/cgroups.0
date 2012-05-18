From: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: make css->refcnt clearing on cgroup removal optional
Date: Fri, 18 May 2012 20:28:56 +0200
Message-ID: <CA+1xoqfr5aaGbxoX3YKrJHXTjU9fWSbX_xbuEOU=4K7kMay6XQ@mail.gmail.com>
References: <20120330223423.GJ28934@google.com> <20120330223606.GK28934@google.com>
 <4F77B6BA.4070207@huawei.com> <20120401185430.GA9230@dhcp-172-17-108-109.mtv.corp.google.com>
 <CA+1xoqe5hMuxzCRhMy7J0XchDk2ZnuxOHJKikROk1-ReAzcT6g@mail.gmail.com> <20120518175548.GM19388@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=T5rsy/1sXJ5XubM+voy40aNm01Q6QtXs0bSrLRWt1kk=;
        b=P2EQp8ImAz5XEIkFnzWePx5utLUw4QjOSh0VhGMB0P68Ld3D8zrpGjU4uiMS/75SIe
         E0gj0bhStJUp2MBd7KwRL2myM6/IJoEXkxKw9XRNsIi2f/JQUzWRP4Yxf2lBDeGr42GB
         hu4wx5yeb0Q1Y5xRe+lKWnIPFJEg3B6H9HmME1H2qiymwzfI7P0rQIK06OFVS+baYKTJ
         SRjXufIc573potGLTemsE+jP7AW11HqrsaDA2jmWUSABW62K/SFax1jCXZQ/WIXSuXQj
         54OMneOvTEH6/wT24PnsT2HzKP/to5fMArL7N/OAmcvdvupHyYbMRuwHFO2g4T59XUuE
         96gQ==
In-Reply-To: <20120518175548.GM19388-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Fri, May 18, 2012 at 7:55 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, May 17, 2012 at 12:33:05AM +0200, Sasha Levin wrote:
>> Hi Tejun,
>>
>> On Sun, Apr 1, 2012 at 8:54 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> > Hello, Li.
>> >
>> > On Sun, Apr 01, 2012 at 10:00:26AM +0800, Li Zefan wrote:
>> >> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> >>
>> >> Both patches look good.
>> >>
>> >> Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> >
>> > Alright, adding the patches to cgroup/for-3.5.
>>
>> This patch allows for race when removing a cgroup since one of the
>> css's may still have a dentry ref when the cgroup is removed, no? Is
>> there a plan to deal with that before this patch gets pushed into 3.5?
>
> Can you please elaborate?

From what I gathered, that patch means that you'll have refs to
dentries while you're trying to complete the unmount of the cgroup,
which would make something really angry.

I tested it by running two scripts to race with eachother:

First:

while [ true ];
do
mount -t cgroup dummy cgroup/
mkdir cgroup/0
rmdir cgroup/0
umount cgroup/
done

Second:

while [ true ];
do
mount -t cgroup dummy cgroup/
umount cgroup/
done

Now, if you give it a go, you'll see a BUG() and a system hang pretty fast.
