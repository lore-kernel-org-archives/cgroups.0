From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v2 0/3] blk-cgroup: some cleanup
Date: Fri, 7 Apr 2023 12:44:52 -0600
Message-ID: <1416b648-188f-873a-08b3-c8e8494ab1a7@kernel.dk>
References: <20230406145050.49914-1-zhouchengming@bytedance.com>
 <cab869b1-1cba-5698-55eb-a93d0596c869@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680893095; x=1683485095;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kzuwp9uE5sEsN7zJHJeiz67QAe8Oc4s0UD0YCNSdM5U=;
        b=O3+MoV6cDmmkPk7W8AJ/froinsO6LnGDj+Z5hsCYMGsWXJkNFNjt/nsjhnZg8+4tI0
         QIrEe1yOg43xQeckg1TGUnwXZa1/PnaY1t00UhDiWa2jXuLWvjMXFEgXly1N1Yt7aE6V
         jf8xC6fLILmQ374PFSo9Kn02mz10UvYv67tQrJMg+nXNykneGweIkXs6t3v7qLeY3kjX
         ILL22YyeQZft7KFN/VKBwR+h326O/A3Pr5c3Fjb0XJVRtQXMKvlvS5/2PBKuhFNg/RsT
         wi1sm10f2dlsbhbFwvZYnDisSUWfifJO1EY/WMx7nLmjkthQbgK1MmDA6byqNJB7BhcA
         YZVw==
Content-Language: en-US
In-Reply-To: <cab869b1-1cba-5698-55eb-a93d0596c869-HInyCGIudOg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 4/7/23 12:41=E2=80=AFPM, Bart Van Assche wrote:
> On 4/6/23 07:50, Chengming Zhou wrote:
>> These are some cleanup patches of blk-cgroup. Thanks for review.
>=20
> With these patches applied, my kernel test VM crashes during boot. The fo=
llowing crash disappears if I revert these patches:
>=20
> BUG: KASAN: null-ptr-deref in bio_associate_blkg_from_css+0x83/0x240

Would be useful in the report to know where that is, as it doesn't include
the code output.

--=20
Jens Axboe


