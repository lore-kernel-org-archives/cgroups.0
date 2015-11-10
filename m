From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH] cgroup_pids: add fork limit
Date: Tue, 10 Nov 2015 10:58:39 -0500
Message-ID: <5642142F.2090302@gmail.com>
References: <144716440621.20175.1000688899886388119.stgit@rabbit.intern.cm-ag>
 <CAOviyaiXSCztjv0d99G-t-yo1wtGzXZr0qpuqcKDBdV=wnMinw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020004030805070605030202"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-type;
        bh=XYBlhRWXMhTeNFHwOWW2qsVT6hMNLbsmKxv6dpIoVqQ=;
        b=gjAAotGn/EJY4xI8miCIGBoXx/6vPknXAE5IM9VGZhgp3sTLlT5PIsE+Su1liOEwrC
         zUGvQDnu50Y0my2tGpsSZqhWRQweijRGMLAOu4ly3u++uQy8QCypsXMIlgautRIoag56
         Q2IMIrR4XYXOvfBtKApVfLGx6FmkUYLwpKb5p1ixkXJc9CkRVZM119jIBnGdmvki+X/C
         8FrkhauAi/63UhuqzRyPQoCxP/4m80YKGs0NmHWyADGZK4qud01xG+XsfG7UCYIJjwiP
         zrX0i0eRtLc8PXppFf1+TeVPe+SEP3y7wZYrmz+uTgtm+6on4U4mQHkBGz6sFifs4uc5
         3iIA==
In-Reply-To: <CAOviyaiXSCztjv0d99G-t-yo1wtGzXZr0qpuqcKDBdV=wnMinw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Aleksa Sarai <cyphar@cyphar.com>, Max Kellermann <mk@cm4all.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, max@duempel.org, linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms020004030805070605030202
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-10 10:25, Aleksa Sarai wrote:
> Processes don't "use up resources" after they've died and been freed
> (which is dealt with inside PIDs). Yes, lots of small processes that
> die quickly could (in principle) make hard work for the scheduler, but
> I don't see how "time spent scheduling in general" is a resource...
> Fork bombs aren't bad because they cause a lot of fork()s, they're bad
> because the *create a bunch of processes that use up memory*, which
> happens because they call fork() a bunch of times and **don't
> exit()**.
While I'm indifferent about the patch, I would like to point out that=20
fork-bombs are also bad because they eat _a lot_ of processor time, and=20
I've seen ones designed to bring a system to it's knees just by=20
saturating the processor with calls to fork() (which is as slow as or=20
slower than stat() on many commodity systems, setting up the various=20
structures for a new process is an expensive operation) and clogging up=20
the scheduler.  This isn't as evident of course when you run a fork-bomb =

on a laptop or similar system, because you run out of memory and PID's=20
before the latency from scheduling and so many processes calling fork=20
really starts to become noticeable, but when you start to look at really =

big systems (on the order of hundreds of GB of RAM), it does become much =

more noticeable.


--------------ms020004030805070605030202
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTEwMTU1ODM5WjBPBgkq
hkiG9w0BCQQxQgRA3UNc3VD43O3uPMPG9sfPVU+c0qFZCheVDQ9n2T47A18kGamkwqmznBsM
G7hSKt+VmY0i+5bW+Tb9qjBFCwUXyDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCE1EGwQqdfu41gP3IBtDP664R//XLnhogKajbYRKhIOfMZHWkx
/g4KecSOGDNeoJa7D+Y+AbRHE4E4y8gifliB70TkasL6eXAy2d1Jsoq1OgHAkUqy/TixI2bY
SFFSTRk3ADG8ZcVBxvGEq6WG/UXjPAVtDLPgU2yKbPay9NWo9eyeaU9mZLi4s9NpiYTKE8XX
T8CRTdbI/sQ77mmUr8rZvg+i9Vex7j1qIFzoqikpE/MbVWQatgHHUDnr2Gtpu89GsUvQB2Uo
46RCkjpv7yRW21PiCZk8M91Xc7pXoHhsmtyM30l7WwYfVvCYBv4lIQmKdpvvdFxUqMLAooY3
bkTYjxMMez0Gw952/kwmNhsaxvDqP5XfUqmNcRp/aX8rW+FLS0xjqBLgATEp6hMHivX9A3h2
uOa29WUWJuNdloaLf8BGKSF7OY6JbpaJo24u1nqngIeiihhKOiDMzK0IOCEnZvgb9SCR/BPt
wACjvNDgh0EX5Yx+FckcJ+NC9zE5DqMjTA5omAfMN+rVV6Hp6eTmIg0ALChDQ2sCFDqEUQvD
l1MQFgaueW+Yw643J/LRssu7L3hTRWnpQgPyv4sPj3hua9JSi+sAOoqPbcwo3/hw4/BD01iL
hlq7OacK52VZ32XJv5g0SKApJIHckJ6dWax38zRAxlUSFgQFdwZQMaNIMAAAAAAAAA==
--------------ms020004030805070605030202--
