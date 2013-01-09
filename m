From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3.4 0/2] 2 bug fixes for the 3.4 cgroup code
Date: Wed, 09 Jan 2013 15:48:39 +0100
Message-ID: <50ED8347.7000806@redhat.com>
References: <1357733486-1742-1-git-send-email-hdegoede@redhat.com> <20130109143850.GG3926@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130109143850.GG3926-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On 01/09/2013 03:38 PM, Tejun Heo wrote:
> Hello, Hans.
>
> On Wed, Jan 09, 2013 at 01:11:24PM +0100, Hans de Goede wrote:
>> Allthough I know everyone dislikes looking back at old code once it has
>> been rewritten in a better fashion, I hope you are still willing to make
>> some time to review these 2 simple patches, as a first step in getting
>> them into 3.4.xx.
>
> Well, the problem is that -stable doesn't take any patch which isn't
> already upstream,

I know that that is the generic rule, but I was hoping Greg KH would be
willing to make an exception. At least I can try :)

I've solved the panic btw, I'll send a v2 of the set right after this
mail, including an explanation what was wrong with v1.

I was hoping that I could get a review from you on v2 including an
Acked-by (assuming the review does not find any issues) before I very kindly
ask Greg KH to make an exception for this.

Thanks & Regards,

Hans
