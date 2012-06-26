From: Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup cgroup]
Date: Wed, 27 Jun 2012 08:00:17 +0900
Message-ID: <CALLJCT10NT_s4fbkiFb8k7LQMQW=YH14YgOD6hCRLxVPOPoncg@mail.gmail.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=D2yLBDCWXdbgNcoPg9hIMLMl/3Z9CcoXUZq8HA7eMDg=;
        b=diGZkZAdpmabENvEE+sms86iD9bqEMDN/OFToTRVmb8ZJfsslmvDyUJMC8PhkYvJ05
         wonljXi3tXw7+gjlEbVcawrPUN2iSmkWvKCdnUBsSlniJCxC9WaCt4vcdOvu08TGa27z
         FUd4XhFb4+iq48X9caR++oe0blhJyE8JKMWsqH8nLg6cuXpx79yTDJ2r+/sR9pk0NjG+
         BCaDyeZEPFvyhrgD5ahblc/NZV68fGmHmIhis9ZPFz/7kmzDTo00LmwxaM7Y6qjSTWCI
         TZbTXeNs5aPXhCO1ZyHW4hiEXkvY2jaKXaxitbHSP3eVoFkmoyPDqoXmEWMClxOhZ3Mm
         HbUQ==
In-Reply-To: <E061084CB90FCE4F89232A6CF839683B32B52291-SY/3K1LPFSqBBfbIEMVH7QK1hpo4iccwjNknBlVQO8k@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello Shyju,
I have also encountered this symptom since 3.5-rc1.
Still exist on 3.5-rc4.  The last known working is 3.4.

In my case, either "shutdown or reboot" or "service cgroup stop"
reproduce this symptom.

I have opened https://bugzilla.kernel.org/show_bug.cgi?id=43771

Masanari
