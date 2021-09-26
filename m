From: =?UTF-8?B?5Y+w6L+Q5pa5?= <yunfangtai09-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [BUG] The usage of memory cgroup is not consistent with processes
 when using THP
Date: Sun, 26 Sep 2021 15:35:34 +0800
Message-ID: <CAHKqYaa7H=M4E-=ObO0ecj+NE2KwZN5d7QSz4_b6tXz2vOo+VA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="00000000000043c54105cce10702"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Sb0engf5YAW0rLpuy9gVSDhYbZE2i/wvwLZEgTdAMSM=;
        b=cx7/UfjAmHfby9ohbkgrVDoMiokDFk6S+GDY/Ux7skpOmmp/yHR7ezm8j+9jnnm1ej
         rCGyCtLAf6xOBt3Otqdg78LIc7Tiwx6cwEIWIFQtZhQQp3s32sXq93RVtCDuEHT4Hg+S
         DWmqgyrzRbTtlWAN2fQ2NKC5/YtqFK+ntPzPLuLK2OjWumsuDvnb7dxrRv7nVoReltLv
         Hzpl/XCI98c6EribS5aQiTECullt+Ls/SiiVpLUTAp6udHqwdyc+f2sP7Z2zG3oB1Qnc
         fY6q1rqsLXhBPY4PjLJGEdWg7xzTarQxaO8kUfVxg0MWXlMj5gEISh3f8ZPikodaN4DM
         TMJg==
List-ID: <cgroups.vger.kernel.org>
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

--00000000000043c54105cce10702
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi folks=EF=BC=8C
We found that the usage counter of containers with memory cgroup v1 is
not consistent with the  memory usage of processes when using THP.

It is  introduced in upstream 0a31bc97c80 patch and still exists in
Linux 5.14.5.
The root cause is that mem_cgroup_uncharge is moved to the final
put_page(). When freeing parts of huge pages in THP, the memory usage
of process is updated  when pte unmapped  and the usage counter of
memory cgroup is updated when  splitting huge pages in
deferred_split_scan. This causes the inconsistencies and we could find
more than 30GB memory difference in our daily usage.

It is reproduced with the following program and script.
The program named "eat_memory_release" allocates every 8 MB memory and
releases the last 1 MB memory using madvise.
The script "test_thp.sh" creates a memory cgroup, runs
"eat_memory_release  500" in it and loops the proceed by 10 times. The
output shows the changing of memory, which should be about 500M memory
less in theory.
The outputs are varying randomly when using THP, while adding  "echo 2
> /proc/sys/vm/drop_caches" before accounting can avoid this.

Are there any patches to fix it or is it normal by design?

Thanks,
Yunfang Tai

--00000000000043c54105cce10702
Content-Type: text/x-c-code; charset="US-ASCII"; name="eat_release_memory.c"
Content-Disposition: attachment; filename="eat_release_memory.c"
Content-Transfer-Encoding: base64
Content-ID: <f_ku0py5fu0>
X-Attachment-Id: f_ku0py5fu0

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHVuaXN0ZC5o
PgojaW5jbHVkZSA8c3lzL3R5cGVzLmg+CiNpbmNsdWRlIDxzeXMvbW1hbi5oPgoKCmludCBtYWlu
KGludCBhcmdjLCBjaGFyKiBhcmd2W10pCnsKICAgIGNoYXIqIG1lbWluZGV4WzEwMDBdID0gezB9
OwogICAgaW50IGVhdCA9IDA7CiAgICBpbnQgd2FpdCA9IDA7CiAgICBpbnQgaSA9IDA7CgogICAg
aWYgKGFyZ2MgPCAyKSAgewogICAgICAgIHByaW50ZigiVXNhZ2U6IC4vZWF0X3JlbGVhc2VfbWVt
b3J5IDxudW0+ICAgI2FsbG9jYXRlIG51bSAqIDggTUIgYW5kIGZyZWUgbnVtIE1CIG1lbW9yeVxu
Iik7CiAgICAgICAgcmV0dXJuOwogICAgfQoKICAgIHNzY2FuZihhcmd2WzFdLCAiJWQiLCAmZWF0
KTsKICAgIGlmIChlYXQgPD0gMCB8fCBlYXQgPj0gMTAwMCkgewogICAgICAgIHByaW50ZigibnVt
IHNob3VsZCBsYXJnZXIgdGhhbiAwIGFuZCBsZXNzIHRoYW4gMTAwMFxuIik7CiAgICAgICAgcmV0
dXJuOwogICAgfQogICAgcHJpbnRmKCJBbGxvY2F0ZSBtZW1vcnkgaW4gTUIgc2l6ZTogJWRcbiIs
IGVhdCAqIDgpOwoKICAgIHByaW50ZigiQWxsb2NhdGlvbiBtZW1vcnkgQmVnaW4hXG4iKTsKICAg
IGZvciAoaSA9IDA7IGkgPCBlYXQ7IGkrKykgewogICAgICAgIG1lbWluZGV4W2ldID0gKGNoYXIq
KW1tYXAoTlVMTCwgOCoxMDI0KjEwMjQsIFBST1RfUkVBRHxQUk9UX1dSSVRFLCBNQVBfQU5PTllN
T1VTfE1BUF9QUklWQVRFLCAtMSwgMCk7CiAgICAgICAgbWVtc2V0KG1lbWluZGV4W2ldLCAwLCA4
KjEwMjQqMTAyNCk7CiAgICB9CgogICAgcHJpbnRmKCJBbGxvY2F0aW9uIG1lbW9yeSBEb25lIVxu
Iik7CiAgICBzbGVlcCgyKTsKICAgIHByaW50ZigiTm93IGJlZ2luIHRvIG1hZHZpc2UgZnJlZSBt
ZW1vcnkhXG4iKTsKICAgIGZvciAoaSA9IDA7IGkgPCBlYXQ7IGkrKykgewogICAgICAgIG1hZHZp
c2UobWVtaW5kZXhbaV0gKyA3KjEwMjQqMTAyNCwgMTAyNCoxMDI0LCBNQURWX0RPTlRORUVEKTsK
ICAgIH0KICAgIHNsZWVwKDUpOwogICAgcHJpbnRmKCJOb3cgYmVnaW4gdG8gcmVsZWFzZSBtZW1v
cnkhXG4iKTsKICAgIGZvciAoaSA9IDA7IGkgPCBlYXQ7IGkrKykgewogICAgICAgIG11bm1hcCht
ZW1pbmRleFtpXSwgOCoxMDI0KjEwMjQpOwogICAgfQoKfQo=
--00000000000043c54105cce10702
Content-Type: application/x-sh; name="test_thp.sh"
Content-Disposition: attachment; filename="test_thp.sh"
Content-Transfer-Encoding: base64
Content-ID: <f_ku0vyq7e1>
X-Attachment-Id: f_ku0vyq7e1

IyEgL2Jpbi9iYXNoCgptZW09NTAwCm1rZGlyIC9zeXMvZnMvY2dyb3VwL21lbW9yeS90aHB0ZXN0
Cmxvb3A9MAp3aGlsZSAoKGxvb3AgPCAxMCkpOwpkbwoJY2dleGVjIC1nIG1lbW9yeTovdGhwdGVz
dCAuL2VhdF9yZWxlYXNlX21lbW9yeSAkbWVtID4gL2Rldi9udWxsJgoJbnVtPWBjYXQgL3N5cy9m
cy9jZ3JvdXAvbWVtb3J5L3RocHRlc3QvbWVtb3J5LnVzYWdlX2luX2J5dGVzYAoJKChudW0gPSBu
dW0vMTAyNC8xMDI0KSkKCWVjaG8gImJlZm9yZSBtZW1vcnk6ICRudW0gTSIKCXNsZWVwIDUKCSNl
Y2hvIDIgPiAvcHJvYy9zeXMvdm0vZHJvcF9jYWNoZXMKCW51bTE9YGNhdCAvc3lzL2ZzL2Nncm91
cC9tZW1vcnkvdGhwdGVzdC9tZW1vcnkudXNhZ2VfaW5fYnl0ZXNgCgkoKG51bTEgPSBudW0xLzEw
MjQvMTAyNCkpCgllY2hvICJhZnRlciBtZW1vcnk6ICRudW0xIE0iCgkoKG51bTEgPSBudW0xIC0g
bnVtKSkKCXJldD0wCgkoKHJldD1tZW0qOCAtIG51bTEpKQoJZWNobyAibWVtb3J5IGxlc3M6ICRy
ZXQgTSwgc3RhbmRhcmQ6JG1lbSBNIgogICAgICAgIHdhaXQKICAgICAgICAoKGxvb3ArKykpCmRv
bmUKY2dkZWxldGUgbWVtb3J5Oi90aHB0ZXN0Cg==
--00000000000043c54105cce10702--
