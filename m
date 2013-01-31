From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 8/9] devcg: refactor dev_exception_clean()
Date: Thu, 31 Jan 2013 10:15:18 +0800
Message-ID: <5109D3B6.9060905@huawei.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com> <20130130171102.253395279@napanee.usersys.redhat.com> <20130130204730.GF8507@mail.hallyn.com> <20130130204917.GL17632@redhat.com> <CAOS58YOHkK9xTBPFAXKksrwP7ZxQc_WuGOp39D94Z1pBsFHfjw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOS58YOHkK9xTBPFAXKksrwP7ZxQc_WuGOp39D94Z1pBsFHfjw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On 2013/1/31 4:50, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jan 30, 2013 at 12:49 PM, Aristeu Rozanski > that's not
> intentional. thanks for catching this
>>
>> Tejun, you want me to resubmit the whole series or just the next patch
>> (where I was supposed to move that chunk)?
> 
> If it doesn't affect the next patch, just posting an updated version
> of this patch should be enough, I think. Which tree are these patches
> planned to go through?
> 

It used to be -mm tree, but I bet Andrew would be happy to see you
route them through your tree. ;)
