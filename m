From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] memcg: revise the position of threshold index while unregistering
 event
Date: Thu, 08 Mar 2012 15:02:50 +0800
Message-ID: <4F58599A.3090100@gmail.com>
References: <1331035943-7456-1-git-send-email-handai.szj@taobao.com> <20120308144448.889337cf.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=Cb2AZo/Nl86+DLLwciiPIZXnRMMxp3vYrcauKpVRWH4=;
        b=0QywaIwWuR1DRKMMYoAZHjDsazFvCTs5eDituFT2OWAgJ15RKSzfjeTS/sUuN6sCBa
         7rMyVT3wJWzng1SVmYSkXuLJFYw2MghuKGnymfHcez3EzmPcDcyCwR9icT64QwkeEcXh
         A3er8YscY/IRPX7cfHqWUEkXJ9VMcB4WEzg0QgGYvnQqJrChElXotz/cc3CIDIzkz6nO
         tjyxBz8xpQPixOI00/4bX+ZkXgC5gCZJjKMUH88ht8Ym4qmqPGam7065dt6jD/Lw+oo8
         tMRI28pzVhH3mRXxN6HCTJpniux1UGqo+4fxUC3W6b3sxa69mzzTyEQ1ImK2ur9eygOD
         V8sQ==
In-Reply-To: <20120308144448.889337cf.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On 03/08/2012 01:44 PM, KAMEZAWA Hiroyuki wrote:
> On Tue,  6 Mar 2012 20:12:23 +0800
> Sha Zhengju<handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>  wrote:
>
>> From: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>
>> Index current_threshold should point to threshold just below or equal to usage.
>> See below:
>> http://www.spinics.net/lists/cgroups/msg00844.html
>>
>>
>> Signed-off-by: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> Thank you for resending.
>
> Acked-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>
It's not a resending, though they are for the same reason.  May be I should
merge them together ...


Thanks,
Sha
