From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH] cgroup_pids: add fork limit
Date: Tue, 10 Nov 2015 14:54:43 -0500
Message-ID: <56424B83.2080504@gmail.com>
References: <144716440621.20175.1000688899886388119.stgit@rabbit.intern.cm-ag>
 <CAOviyaiXSCztjv0d99G-t-yo1wtGzXZr0qpuqcKDBdV=wnMinw@mail.gmail.com>
 <5642142F.2090302@gmail.com>
 <CAG53R5XfNjuBcwNZW4pB_bhq2+vLoo1UKQ7Rqhx=TdLMa5abuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040909010407020101030605"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-type;
        bh=j+vUdJLqdSF5eXuiRzBlrBGDWlKRZbk+7aASsprqwXw=;
        b=gFT47OCyalgECGyYD4vuPlZr7Hr4OYXc1/TFRt3tWpJ/tXPRR0bGdWYky9mwgL9Zhl
         fh5MdFrqlP6QDDER886R9R07dt9WgZf2s13zEKZsop/X1EOEfw3j8u6pSriAc1xxJ9cw
         G3h3nNLYeBtx+6y+l5Px2ZbhgYh2/BNQrfGTl+dhIP478+1i2wiN/jMHFd+czJ+avPP6
         8MahWca3ECPbZ9lBM0tFwRfKc6KJbZCqHC8Ot+eJiDmQdkN9eQD3TKVeKB8Ui5CThSoh
         XfqPYfIAo0b/YDsLk03znjPMhnmQcsqWCQZCSfI5lcYVDfIaX5hl+Fr1lUendaUsmaqC
         CFRQ==
In-Reply-To: <CAG53R5XfNjuBcwNZW4pB_bhq2+vLoo1UKQ7Rqhx=TdLMa5abuw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Parav Pandit <pandit.parav@gmail.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Max Kellermann <mk@cm4all.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, max@duempel.org, linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms040909010407020101030605
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-10 11:19, Parav Pandit wrote:
> On Tue, Nov 10, 2015 at 9:28 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-11-10 10:25, Aleksa Sarai wrote:
>>>
>>> Processes don't "use up resources" after they've died and been freed
>>> (which is dealt with inside PIDs). Yes, lots of small processes that
>>> die quickly could (in principle) make hard work for the scheduler, bu=
t
>>> I don't see how "time spent scheduling in general" is a resource...
>>> Fork bombs aren't bad because they cause a lot of fork()s, they're ba=
d
>>> because the *create a bunch of processes that use up memory*, which
>>> happens because they call fork() a bunch of times and **don't
>>> exit()**.
>>
>> While I'm indifferent about the patch, I would like to point out that
>> fork-bombs are also bad because they eat _a lot_ of processor time, an=
d I've
>> seen ones designed to bring a system to it's knees just by saturating =
the
>> processor with calls to fork() (which is as slow as or slower than sta=
t() on
>> many commodity systems, setting up the various structures for a new pr=
ocess
>> is an expensive operation) and clogging up the scheduler.
>
> Isn't cpu cgroup helpful there to limit it?
Possibly, I don't know the specifics of how it handles stuff executing=20
in a context technically outside of a process on behalf of that process. =

  I'm almost 100% certain that there is no sane way it can account and=20
limit time spent in the scheduler because a process is spawning lots of=20
children.
> Are you saying time spent by scheduler is more that actually affects
> the scheduling of processes of other threads?
In some cases yes, although this is very dependent on the system itself=20
(for example, if you have a really low /proc/sys/pids_max, it will never =

be an issue, but that will also make it easier for a fork-bomb to make=20
your system unusable).  The scheduler on Linux is comparatively fast for =

how feature rich it is, but it still slows down as you have more and=20
more processes to schedule.  If you have a lot of RAM proportionate to=20
your processing power (as in, multiple GB on a processor running at only =

a few MHz, and yes such systems do exist), then the scheduling overhead=20
is much more significant than the memory overhead.  Even without such a=20
situation, it's fully possible to weigh down the system with overhead=20
from the kernel.  As an example, a on a Raspberry Pi (single core 700MHz =

ARM11stj-z CPU, 512MB of RAM), you can spawn a few hundred processes=20
each just sitting on an interval timer set so that every time the=20
scheduler runs, at least 10% of them are runnable (and I've seen=20
fork-bombs that do this), and you will render the system unusable not=20
because of memory consumption, but the scheduling and timer overhead.
> If so, could you share little more insight on how that time measure
> outside of the cpu's cgroup cycles? Just so that its helpful to wider
> audience.
Well, there are a number of things that I can think of that the kernel=20
does on behalf of processes that can consume processor time that isn't=20
trivial to account:
   * Updating timers on behalf of userspace processes (itimers or similar=
).
   * Sending certain kernel generated signals to processes (that is,=20
stuff generated by the kernel like SIGFPE, SIGSEGV, and so forth).
   * Queuing events from dnotify/inotify/fanotify.
   * TLB misses, page faults, and swapping.
   * Setting up new processes prior to them actually running.
   * Scheduling.
All of these are things that fork-bombs can and (other than TLB misses)=20
do exploit to bring a system down, and the cpu cgroup is by no means a=20
magic bullet to handle this.


--------------ms040909010407020101030605
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTEwMTk1NDQzWjBPBgkq
hkiG9w0BCQQxQgRAW5v8tQvE0mC/NdrIy641tkjvwyrqu2VXIVwH0WH1ykY7y2tjLehq/sjW
BvGCN0+eX8GvZYi+hPxttlybAQDJ5jBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBjJcXWE9ImqxfVo9iSU6XrBj94vXGm+nKDR+A62LHXOUF7BbDq
wH3MFIxlrKlKiXnQz/JQrE4dIZ3esEp7oG4ATnl0/bPDsCIDM63IrMjqDihzpHmAbKeny66v
MIks4Zsz7k0w/0J7GzpYHgavC1mmCg3at9EJZZ2pX6JXVJfrr1yAhrsgQNMKE4kzjawpoQkB
32P5uqJi2w36T81xqpjPBsqRKF+0rCRr37ahXRC1LFE2T28K34l0rlZ9xjBHxKrc2ctLoo1X
2Eqmnyn9HS6XtcFyD3mr0alYusdAtIWxaTRYcvNF2AmdVzfgrj1zkjpiqWaboHkaS/sINTF2
++OoNaVIBARrnSYnsxMsMr87P3Oc8zESC7gGpMyS+/x+Qs0cflHbxgSHac/FkfsooZ0wr54l
czlK7cigoOceObJkypEdWpS1I1UPHMgVOrqGbYv8DDQcrJ2mMZpT4A6PWHrJStIRT/lTin9F
nmcCiZZT8GwnEfWQsLA9yAS6H6EEJM6CfU8QlT3DFFPPgC29Lq6yzJoWRyb6OhEUPK1LV44d
t/AnC0BTryvoiC+k/g7vpUH1f8NtXLMySuuOYKMWg7rb755mWNExSA674LBupU9GubMa0e9c
Vby9lXj+ZCZxmoNV76/cLVs1CSOzb+7Mo8Pudpig7zH5OJWNp4l+acJ/BgAAAAAAAA==
--------------ms040909010407020101030605--
