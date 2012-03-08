From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] memcg: revise the position of threshold index while unregistering
 event
Date: Thu, 08 Mar 2012 17:37:44 +0800
Message-ID: <4F587DE8.6090005@gmail.com>
References: <1331035943-7456-1-git-send-email-handai.szj@taobao.com>	<20120308144448.889337cf.kamezawa.hiroyu@jp.fujitsu.com>	<4F58599A.3090100@gmail.com> <20120308163028.df8b6bde.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=Q8QjJPZKXd23ff6il98224K981gG1hh5QOrqmARodIg=;
        b=My4TBnEQqnN91wTIVu9Rf953Xaqh8mF3c8+6cQln2vtGncSIlGfuU8B/J5NVccxfMh
         EAD+XWq51nKg4pH5chlaHjOVsN8ZPNC9Cfiv2p7H+61vtbw9zc19L7C0o/DvirbZI9zU
         UDN9BuF/QNTFJ/jN5dCvZx6W/lzrqewFG5IkuVa066OmjhabdGpmcJomBhd5qijANrys
         a6dRcOJMezV5SIqYWDhgAJUfRlWt8IXxJzHymZi1DA3wfWhTaY0Jo9+XhaJfZZBF+uN7
         fKQp5pXrlw+h5kCWJnfLXwHaqvtwRaJZhpjg5NEoxOuIRH5S1kqXy5TujeLF0+Cj9ky3
         sO3g==
In-Reply-To: <20120308163028.df8b6bde.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On 03/08/2012 03:30 PM, KAMEZAWA Hiroyuki wrote:
> On Thu, 08 Mar 2012 15:02:50 +0800
> Sha Zhengju<handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>  wrote:
>
>> On 03/08/2012 01:44 PM, KAMEZAWA Hiroyuki wrote:
>>> On Tue,  6 Mar 2012 20:12:23 +0800
>>> Sha Zhengju<handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>   wrote:
>>>
>>>> From: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>>>
>>>> Index current_threshold should point to threshold just below or equal to usage.
>>>> See below:
>>>> http://www.spinics.net/lists/cgroups/msg00844.html
>>>>
>>>>
>>>> Signed-off-by: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>> Thank you for resending.
>>>
>>> Acked-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>>>
>> It's not a resending, though they are for the same reason.  May be I should
>> merge them together ...
>>
> Ah. Hmm..If your previous patch isn't picked up yet, could you send it again
> (or merge and post merged one ) ?
>
> Thanks,
> -Kame
>
Ok, I'll send a new version one later. :-)

Thanks,
Sha
