From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/3] loop: Charge i/o to mem and blk cg
Date: Tue, 29 Jun 2021 12:26:21 +0200
Message-ID: <YNr1TYfBwR/tEpEJ@blackbook>
References: <20210610173944.1203706-1-schatzberg.dan@gmail.com>
 <20210610173944.1203706-4-schatzberg.dan@gmail.com>
 <YNXvr81YFzbaTxCb@blackbook>
 <YNnZ7hIRIk9dJDry@dschatzberg-fedora-PC0Y6AEN>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8xak29pAuRs/xS4S"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624962382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4nnJd/WQSpUTtWERcTYMKjk7Xm3bTS7VSG5SjPdv9Bc=;
        b=SIOiyfS7XfAvoPmQiyHYe5i2CqhxV09toMQQiEzN+oosnPqqz8XsULnowsgVFUZwJqTTwP
        GUzX0vNQaS1ETRJIiLWMUmwhOELlrPWsRhQL2Zvfmw1QaOY5z3ckCm/xaKpIfv9AaWwOgM
        LUKvYk0acBAFboy9Nt9XSeD/pPvh0Qk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624962382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4nnJd/WQSpUTtWERcTYMKjk7Xm3bTS7VSG5SjPdv9Bc=;
        b=SIOiyfS7XfAvoPmQiyHYe5i2CqhxV09toMQQiEzN+oosnPqqz8XsULnowsgVFUZwJqTTwP
        GUzX0vNQaS1ETRJIiLWMUmwhOELlrPWsRhQL2Zvfmw1QaOY5z3ckCm/xaKpIfv9AaWwOgM
        LUKvYk0acBAFboy9Nt9XSeD/pPvh0Qk=
Content-Disposition: inline
In-Reply-To: <YNnZ7hIRIk9dJDry@dschatzberg-fedora-PC0Y6AEN>
List-ID: <cgroups.vger.kernel.org>
To: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>


--8xak29pAuRs/xS4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 28, 2021 at 10:17:18AM -0400, Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Agreed that exporting int_active_memcg is an implementation detail,
> but would this prevent set_active_memcg from being inlined?

Non-inlining in the loop module doesn't seem like a big trouble. OTOH,
other callers may be more sensitive and would need to rely on inlining.
I can't currently think of a nice way to have both the exported and the
exlicitly inlined variant at once. It seems it's either API or perf
craft in the end but both are uncertain, so I guess the current approach
is fine in the end.

> Yes it is intentional. All requests (not just aio) go through the loop
> worker which grabs the blkcg reference in loop_queue_work() on
> construction. So I believe grabbing a reference per request is
> unnecessary.

Isn't there a window without the reference between loop_queue_rq and
loop_queue_work? I don't know, you seem to know better, so I'd suggest
dropping a comment line into the code explaining this.

Thanks,
Michal

--8xak29pAuRs/xS4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmDa9UkACgkQia1+riC5
qShOvQ/+IAbayEL5mDzde7avlf2IctIAGpgzfJMiT0f2HjZlZvc+wZyRZtbY48+f
qQvyKrqzoa8urrykaJOPImzej1n5/+LPnxg/EdPXMLf3GP69aeRWx/UFSkiPpCeJ
jw5r2FbQE29yfQYAtuHbL6IPnfa1JDkQXroHwN+MIsNqayGiz2FbE4fxPJxR8hkt
xCYjCyNMzBEw1b334gUvj8XrFRbzfgIJokZ3UNVIrRcv/rbYKs4LplelQ5dGEjpp
uzFAC5QDabn78+SJ6c7h5ReTx4zdPC+9A3FlZXBWxkpSPiPEPO6b0Qdo86p4v4eA
MGT8fNcfyvjQZdzckZ1oHylUCBbDhCIons6PmEqpEDd5ZFA5taD9G6YRGyH1G7Kb
EieXPoCynJWRCdHat3PeqTpnf9oYPsaiBXozn2UXdK2Rvv2+g9A5am/AKN+I2Y+J
xgzp9FPA5nRx5Z8oIAl9iqvb8mfrlYPn0CsNnzo+eHE13Zh7nxlFQrrqJsnjaQ2J
45wPm24rg9XrKoTIpLs0O1INWqNjkweqPRLs5I/ClXRWkqXkfJ5cUchEjsLqksVJ
SunkIX+LxIWE/Fb23d2jio51pC26W4gcAtOTTe6MZ/Iqq7LI7cpKX9bGW1dkrKgB
nWkJth7TDCL8bIeOjDMMsNVW05el1qQcPei4GZ4sfBjJu6FlikM=
=q9SM
-----END PGP SIGNATURE-----

--8xak29pAuRs/xS4S--
