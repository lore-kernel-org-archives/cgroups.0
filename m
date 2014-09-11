From: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] memcg: add threshold for anon rss
Date: Thu, 11 Sep 2014 13:20:34 -0400
Message-ID: <5411D9E2.5030408@gmail.com>
References: <cover.1410447097.git.vdavydov@parallels.com> <b7e7abb6cadc1301a775177ef3d4f4944192c579.1410447097.git.vdavydov@parallels.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000609080005020801020809"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:disposition-notification-to:date:from:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:content-type;
        bh=HLkiYcotiKdaOKZipojzhtXM/99kip700o2Bj1bRgM8=;
        b=PnNbJZCs+Huo+PT/HSKLat8zjHJoiaRvdr5seQrdP6P+XJenK5N6LKJhxLSN6zYWSY
         MO2wgbqpQz72pHhFjCSyHWexrGSlD/DGmJS4C1Zmf89n6jF4BZlWr2irJpMOwU231S7O
         Kij0MEcYYE6u8Exhpxmt1VDIco6RnDf2jKEVDJnmMOQGqbcAVXg5pLDgaWAV+rssElof
         jsd5UCWjlwOjU63+nR4cLx5PhbT3ZOmCoa82FUL2HMmqfJ7vzyrjZ+C1EXqi1bvSU+/9
         CQFM4+UIGP3C7Ax27NdEk5XdBE6OQdCD2KFom2B/42cb0jn50qqz7RyZr16XHvtMQ+BV
         Kmjg==
In-Reply-To: <b7e7abb6cadc1301a775177ef3d4f4944192c579.1410447097.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Motohiro Kosaki <Motohiro.Kosaki-gkcJ3tX5bYHQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pavel Emelianov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Konstantin Khorenko <khorenko-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a cryptographically signed message in MIME format.

--------------ms000609080005020801020809
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-09-11 11:41, Vladimir Davydov wrote:
> Though hard memory limits suit perfectly for sand-boxing, they are not
> that efficient when it comes to partitioning a server's resources among=

> multiple containers. The point is a container consuming a particular
> amount of memory most of time may have infrequent spikes in the load.
> Setting the hard limit to the maximal possible usage (spike) will lower=

> server utilization while setting it to the "normal" usage will result i=
n
> heavy lags during the spikes.
>=20
> To handle such scenarios soft limits were introduced. The idea is to
> allow a container to breach the limit freely when there's enough free
> memory, but shrink it back to the limit aggressively on global memory
> pressure. However, the concept of soft limits is intrinsically unsafe
> by itself: if a container eats too much anonymous memory, it will be
> very slow or even impossible (if there's no swap) to reclaim its
> resources back to the limit. As a result the whole system will be
> feeling bad until it finally realizes the culprit must die.
I have actually seen this happen on a number of occasions.  I use
cgroups to sandbox anything I run under wine (cause it's gotten so good
at mimicking windows that a number of windows viruses will run on it),
and have had issues with wine processes with memory leaks bringing the
system to it's knees on occasion.  There are a lot of other stupid
programs out there too, I've seen stuff that does it's own caching, but
doesn't free any of the cached items until it either gets a failed
malloc() or the system starts swapping it out.
>=20
> Currently we have no way to react to anonymous memory + swap usage
> growth inside a container: the memsw counter accounts both anonymous
> memory and file caches and swap, so we have neither a limit for
> anon+swap nor a threshold notification. Actually, memsw is totally
> useless if one wants to make full use of soft limits: it should be set
> to a very large value or infinity then, otherwise it just makes no
> sense.
>=20
> That's one of the reasons why I think we should replace memsw with a
> kind of anonsw so that it'd account only anon+swap. This way we'd still=

> be able to sand-box apps, but it'd also allow us to avoid nasty
> surprises like the one I described above. For more arguments for and
> against this idea, please see the following thread:
>=20
> http://www.spinics.net/lists/linux-mm/msg78180.html
>=20
> There's an alternative to this approach backed by Kamezawa. He thinks
> that OOM on anon+swap limit hit is a no-go and proposes to use memory
> thresholds for it. I still strongly disagree with the proposal, because=

> it's unsafe (what if the userspace handler won't react in time?).
> Nevertheless, I implement his idea in this RFC. I hope this will fuel
> the debate, because sadly enough nobody seems to care about this
> problem.

So, I've actually been following the discussion mentioned above rather
closely, I just haven't had the time to comment on it.
Personally, I think both ideas have merits, but would like to propose a
third solution.

I would propose that we keep memsw like it is right now (because being
able to limit the sum of anon+cache+swap is useful, especially if you
are using cgroups to do strict partitioning of a machine), but give it a
better name (vss maybe?), add a separate counter for anonymous memory
and swap, and then provide for each of them an option to control whether
the OOM killer is used when the limit is hit (possibly with the option
of a delay before running the OOM killer), and a separate option for
threshold notifications.  Users than would be able to choose whether
they want a particular container killed when it hits a particular limit,
and whether or not they want notifications when it gets within a certain
percentage of the limit, or potentially both.

We still need to have a way to hard limit sum of anon+cache+swap (and
ideally kmem once that is working correctly), because that useful for
systems that have to provide guaranteed minimum amounts of virtual
memory to containers.


--------------ms000609080005020801020809
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFuDCC
BbQwggOcoAMCAQICAw9gVDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA4
MDgxMTMwNDRaFw0xNTAyMDQxMTMwNDRaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDdmm8R
BM5D6fGiB6rpogPZbLYu6CkU6834rcJepfmxKnLarYUYM593/VGygfaaHAyuc8qLaRA3u1M0
Qp29flqmhv1VDTBZ+zFu6JgHjTDniBii1KOZRo0qV3jC5NvaS8KUM67+eQBjm29LhBWVi3+e
a8jLxmogFXV0NGej+GHIr5zA9qKz2WJOEoGh0EfqZ2MQTmozcGI43/oqIYhRj8fRMkWXLUAF
WsLzPQMpK19hD8fqwlxQWhBV8gsGRG54K5pyaQsjne7m89SF5M8JkNJPH39tHEvfv2Vhf7EM
Y4WGyhLAULSlym1AI1uUHR1FfJaj3AChaEJZli/AdajYsqc7AgMBAAGjggFZMIIBVTAMBgNV
HRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUg
Zm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEE
AYI3CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8v
b2NzcC5jYWNlcnQub3JnMDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuY2FjZXJ0Lm9y
Zy9yZXZva2UuY3JsMDQGA1UdEQQtMCuBFGFoZmVycm9pbjdAZ21haWwuY29tgRNhaGVtbWVs
Z0BvaGlvZ3QuY29tMA0GCSqGSIb3DQEBDQUAA4ICAQCr4klxcZU/PDRBpUtlb+d6JXl2dfto
OUP/6g19dpx6Ekt2pV1eujpIj5whh5KlCSPUgtHZI7BcksLSczQbxNDvRu6LNKqGJGvcp99k
cWL1Z6BsgtvxWKkOmy1vB+2aPfDiQQiMCCLAqXwHiNDZhSkwmGsJ7KHMWgF/dRVDnsl6aOQZ
jAcBMpUZxzA/bv4nY2PylVdqJWp9N7x86TF9sda1zRZiyUwy83eFTDNzefYPtc4MLppcaD4g
Wt8U6T2ffQfCWVzDirhg4WmDH3MybDItjkSB2/+pgGOS4lgtEBMHzAGQqQ+5PojTHRyqu9Jc
O59oIGrTaOtKV9nDeDtzNaQZgygJItJi9GoAl68AmIHxpS1rZUNV6X8ydFrEweFdRTVWhUEL
70Cnx84YBojXv01LYBSZaq18K8cERPLaIrUD2go+2ffjdE9ejvYDhNBllY+ufvRizIjQA1uC
OdktVAN6auQob94kOOsWpoMSrzHHvOvVW/kbokmKzaLtcs9+nJoL+vPi2AyzbaoQASVZYOGW
pE3daA0F5FJfcPZKCwd5wdnmT3dU1IRUxa5vMmgjP20lkfP8tCPtvZv2mmI2Nw5SaXNY4gVu
WQrvkV2in+TnGqgEIwUrLVbx9G6PSYZZs07czhO+Q1iVuKdAwjL/AYK0Us9v50acIzbl5CWw
ZGj3wjGCA6EwggOdAgEBMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6
Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEh
MB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwCQYFKw4DAhoFAKCCAfUw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwOTExMTcyMDM0
WjAjBgkqhkiG9w0BCQQxFgQUPHIim/I1Bri2mtmLnmAebTwaQR4wbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEApvJsx/WUDBKpYkXn9FaLggpOpWUB
sB36Ipc8d3jtAcwO2Sdfse+wL/o/jaJTDh8s86Plsg7qKPg/or0W/5RGaNWUbkOLZWspDU07
qiNT6FBpQ105O639xnzB4BtwpcBNdfpEDVM0cX+LsU/JqIlzYPZdKmNJfDwTDNN53XVhqOZ4
2UBYjD2yoEjiK++uuvYImNC37LUbeQ7EBsNGQx3yJl6qFuOsgwxtuBlGUp0DNgRY8Q4cfo8w
BQqwYCdU+v4GHhVANgyBTFcVvsDEI8/1BYTSN78ZefJdyPCI+EwQGjAJjgaeggwXHhNXnRMK
Mvpg0ggk1ZGhRxPYHMmg2as+rQAAAAAAAA==
--------------ms000609080005020801020809--
