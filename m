From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] memcg: Free spare array to avoid memory leak
Date: Fri, 09 Mar 2012 12:07:32 +0800
Message-ID: <4F598204.9030504@gmail.com>
References: <1331036004-7550-1-git-send-email-handai.szj@taobao.com> <20120309124021.810f5267.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=VEBlJdO6+PPrJ52IzIU1O1PKnfrh6gVO3A1+UjTFgHs=;
        b=lhtWbTJPNxo9w1bKXbL1ERHsk6rZQgUaXxtv0t2AjOGr+n79zyficLl7NDz6+4eIXe
         Nw6wIFATGHnd3M7/b53/FPbSiBqFuyfg8Jrmg1TDUT+jzJkwVqzrpEFEN31LseCUwqjF
         W89c+QGLMSt6JaMaa5N1ZCe5Cecgq+DnH9YTeOxwrgdYGC9FIvLJmnaVTOF94tbdWWa7
         2mtlMwejA7D8ZtjtftiOY21dsQLttohddv5aYS759ZY7VYrF4aCmsIAPCDHAqSMScjUw
         ouoMMHCNvv1NLYLH5fJ8B2vjOMDcJ2ynBTaH4Lh8yRICWt6uWKe9XyPZSsEXFzuvKbUz
         9WtA==
In-Reply-To: <20120309124021.810f5267.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On 03/09/2012 11:40 AM, KAMEZAWA Hiroyuki wrote:
> On Tue,  6 Mar 2012 20:13:24 +0800
> Sha Zhengju<handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>  wrote:
>
>> From: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>
>> When the last event is unregistered, there is no need to keep the sp=
are
>> array anymore. So free it to avoid memory leak.
>>
>> Signed-off-by: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>
>> ---
>>   mm/memcontrol.c |    6 ++++++
>>   1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 22d94f5..3c09a84 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4412,6 +4412,12 @@ static void mem_cgroup_usage_unregister_event=
(struct cgroup *cgrp,
>>   swap_buffers:
>>   	/* Swap primary and spare array */
>>   	thresholds->spare =3D thresholds->primary;
>> +	/* If all events are unregistered, free the spare array */
>> +	if (!new) {
>> +		kfree(thresholds->spare);
>> +		thresholds->spare =3D NULL;
>> +	}
>> +
> Could you clear thresholds->primary ? I don't like a pointer points t=
o freed memory.
Do you meaning I should set =E2=80=98thresholds->primary =3D NULL=E2=80=
=98 =EF=BC=9F
But the following rcu_assign_pointer will do this :

+	/* If all events are unregistered, free the spare array */
+	if (!new) {
+		kfree(thresholds->spare);
+		thresholds->spare =3D NULL;
+	}
+
  	rcu_assign_pointer(thresholds->primary, new);<---------*HERE*

  	/* To be sure that nobody uses thresholds */
