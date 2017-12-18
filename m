From: Bronek Kozicki <brok-CgwIDsGnGWjby3iVrkZq2A@public.gmane.org>
Subject: Re: PROBLEM: NULL pointer dereference in kernel 4.14.6
Date: Mon, 18 Dec 2017 19:56:17 +0000
Message-ID: <95d82ae1-fe4c-4eee-8e94-fa0df3e25532@incorrekt.com>
References: <1513512885.3653140.1207725096.395A9CCC@webmail.messagingengine.com>
 <eccdc57d-d5ea-ddc5-9f07-269e4a6786ae@incorrekt.com>
 <08995310-d853-ee77-ed1f-26cc336a4a30@incorrekt.com>
 <20171217232448.yfaxxew2ijaay7iu@shells.gnugeneration.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=incorrekt.com;
         h=cc:content-transfer-encoding:content-type:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gsm7tlbG4htZ9rHsN
        GfZzrJoLHJltM+Yq+ny2kJKjOA=; b=HLoqx8mQzC84wZvd5MOGGCsM3BZDfMOwg
        K//36gKmH4OIHOeARMAow2MSiH5fydUSKaIYmY1T/i2B/snOYNIgjE+COtbnOHvq
        oPHiGOZy+I0e2iCwry4tBl7yxeDndE/gadiXIiahYpof67MyUNztrEalgFrNxp7U
        17FJuRPdg3sXJgk9zASKb+YgaLb+MZqmzHIO6cpcJUi+QzdoNmsD6EMafln0Ct+m
        wjEfg+6Cwf0f8Q8vq0FBAA72VPN9RDYk3a1yu/85KqJLt9XyrJHZgbLAy0293o8R
        4vHIouYC/R2hjzQeY0scDA7gC/vb29G92HIhdOVs4rIOlzMvdU4Jw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gsm7tl
        bG4htZ9rHsNGfZzrJoLHJltM+Yq+ny2kJKjOA=; b=joZGirbigvSH5XOUm2Ow5c
        LFhQL4IBus+olIbAsbHTCy8AN2roo1mxv+DQ9FL9UpErKKPIO/WxFXpzafyRYZQb
        XuqAbj2lxTH0x5Rx2vmarlXqjHTinEcpr5g0m8LhOTYPnB0D/nTWRra2bN4GBEec
        KkIjYji74kMN52OuTPFtQff2ThKbxRqJ+fBEYUsGrb7jyW829r14X6vQD1C/0+/p
        GOBtPFfZ+ezQ2KVsUgHq0L/irQ2d/4zUiRuk+w/TJ+BowIl/169aCBBCWYUj2zHd
        gXMaJNQfz+xTfn5K4FgeMGSqaapXS2j/6frUXg77KjD5qHSG1UarRHSmcwbnHR7w
        ==
In-Reply-To: <20171217232448.yfaxxew2ijaay7iu-5Y5FpTStZqUl8ZggnyUIT4tm+1EbUQKi@public.gmane.org>
Content-Language: en-GB
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: vcaputo-IiWei5kqaphBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 17/12/2017 23:24, vcaputo-IiWei5kqaphBDgjK7y7TUQ@public.gmane.org wrote:
> On Sun, Dec 17, 2017 at 05:49:44PM +0000, Bronek Kozicki wrote:
>> I just upgraded to 4.14.7 and tried to reproduce this error, this time under strace. As you can see this happens when systemctl tries to read a specific entry under /sys/fs . In case this matters, the entry is for a small virtual machine running under qemu/kvm and managed by libvirt.
>>
>> open("/sys/fs/cgroup/unified/machine.slice", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 5
>> fstat(5, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
>> getdents(5, /* 12 entries */, 32768)    = 464
>> openat(AT_FDCWD, "/sys/fs/cgroup/unified/machine.slice/machine-qemu\\x2d1\\x2dkartuzy\\x2dspice.scope/cgroup.procs", O_RDONLY|O_CLOEXEC) = 8
>> fstat(8, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
>> read(8,  <unfinished ...>)              = ?
>> +++ killed by SIGKILL +++
>> [1]    12078 killed     strace -- systemctl status
>>
>>
> 
> This recently came through lkml, may be related:
> https://marc.info/?l=linux-kernel&m=151320108922415&w=2

thank you, it certainly seems related. Is there some debugging option I could enable, or patch I could apply, which would make the point of data corruption easier to find? I'm ok taking untested patches, if that helps finding the location of the bug.


B.
