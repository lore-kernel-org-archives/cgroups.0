Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794217340;
	b=l4By8mvRWXZVE1NaZvDwSxb5cFAc+H0K3p9PNK+FIQGTsUIuOx5N1E2Wp6r1KaOuRyig
	 rZkIE78iHYEinH5oYESyQb2hgyCjslv9aAnRqUcrT8LKr8Qr1fsie5suJnG3wSa+sKtON
	 3DjUejD7U77vi85gImzViEp23yYZTaMUpgHveUBJnPp0FlB0giUtJ+TDENJiVAbshWm9k
	 3ldMCA+fR9vR7jl/ObJ/wlqsyIDCcdtgABvsgSFYNfdP6UsUum1pZAICWUWTM1GEjqDqj
	 gXgqrQiPqM2fDDdrHX4ykUrrrz9HX0/LBZ2E940J7lFSm63qqXs7LuUnnFz6wHmwLkw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217340;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=dnTFqC7NFZ6LKcry7zosB7nFvDvPqEPM5rGL/V6wgTk=;
	b=z5+a5ByzK4vtweVph1ixgkbBepUB2MkwHh0jBvWnjY1T1kHa9fncXJ0hQfzEWD14d2Ly
	 5hDrYYrEsNTCb8sj2N0YV+AOocmpS7NrUkPFpbymMLSfI51bkciI+Cy9fPgDVlaAnJqCs
	 6L+pBLD9AcEVR1AsPLmMLog498Rh9I3/3Z06WZs4fxh7h+o7Ng4Uaw9PkRVwD6Xt4aPiV
	 r0QIU63IjgdA4ojsBW0h5XnhmC5bcsfKqiCZPXiF2YpHWTTOnZ5hvBsE618OYE5tlopwA
	 /pc2NmVc+poGk2BU6ENFL0sg7+CHZ3m4GlqMP30vU1zy+Qdmd83VznrjMjPbwrjUwaw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IW2nD7TB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.46
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C990606A338
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 09:42:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C990606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IW2nD7TB
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5c144eb2f43so2434e87.1
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 01:42:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794217338; cv=none;
        d=google.com; s=arc-20260327;
        b=Yv4IhHb67DrxZ6Cj5y6R73LNguLT2xlOKQjWsBuQ0h8W/d5EVTXgtXUvOY8tQGJ6Et
         aj92eQdDZr1p9RHhpwU0Ku5FiXF+J6F3PX1xJTZWWi3nrE5SNqYrRyWg+eLu2VMkZF0E
         87DU+0yFipiOwA6kJ+yXi3gYLzUqQXj2ffpU//0L3MxY7/yEiz0hTEs9EnsDJukDt+uH
         Ypl+VG79sORGRfheyr23PNC1z6vp7Y6bAho6wD4gdW7Jwtx3ro2U4nSobpA1ZJNfmFq9
         +V4F5djeulXN4PgnLU1Osz9EvCpKsiXg32TooqLk2abG9GQ3OndbwBkY1RchUGo0DPU4
         /OKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=dnTFqC7NFZ6LKcry7zosB7nFvDvPqEPM5rGL/V6wgTk=;
        fh=yXawXvQx/iyZPEQlx+xpWFoKfHQDkrG22vgAb6mUGJQ=;
        b=FbI0b3smS9w7q9edaHxDTkHx3bmaC1kckzc1oCwUkEqr+EnHP4xZ9EvpOdFymptFyV
         8zC1OSIKZ282UJWh3mHtMRMhASev8csri72u2csdRQLL8dAvXBJwgexIpwv2uKhav8Q/
         GgkQSxf9jG/dzFhG2tXRhlWYDhuVU7snt9W+j7jhiAJBqQH0OgBYr051XYTHmutIyzWH
         Tud5TUZMI9D0ZOKI13eHfR4mIOdoiJ/y4tjE8Ptl6xgT8/QExbBIz1uoH7Nx3h1FJ+nC
         wNM8hDtmUcqOoAyrcrDnTx5w32CDvB1yisGdXGQgc3zkGv/SV0KHdcsX+dBFYDNmH0ij
         lhAg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794217338; x=1794822138; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dnTFqC7NFZ6LKcry7zosB7nFvDvPqEPM5rGL/V6wgTk=;
        b=IW2nD7TBfpylCv/Q4iwboGxtpYLm77TPNHjYntv3vZdOMn07KGEJ8Z+jzF7pqd73le
         R6C3pFcK024lUnAUYKpxEFVxXng9CqVrBsfIHokmvrFogJT4mwvbtoNbjyd3zvhbR9dO
         Tw4VheWTrTOXCPqeGvIvJzC0Z6HIIVEnDDj9Ns+YAcSq1balXLUBN48TiDzLXdzu41kR
         9VnpZtANr8A3VW8NxsBcw0PmQ4QkW8RflYfoiuG3LnC/PhIWHCa6XOWCsah8JQe3bTgn
         Z0femMdJtIO84tqoLbepZiwyEsrNjYhK8lTxSrG6d3YNLh0lwnObvVFb9AYP4xZUrn7u
         1R7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794217338; x=1794822138;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dnTFqC7NFZ6LKcry7zosB7nFvDvPqEPM5rGL/V6wgTk=;
        b=kb2zDFinD5MULUdsb7zBLJxAntSJn3YOa3wA6B0jRoWdrhVeEF2vU1aZ6O61qBWuNa
         AlmnDFltHBdHNG+35r3X9EltqE8k1SgZymN4r/AwhPGo6DUi17RbfxHpdtBFUAHRYZ5y
         O6LEfkt3Px7X688O67PFLubpu2AeCUHwGXsTjfe8OWe+BJRRG0n4tntczOskuXv9qf1d
         bRl64UnS6csM7yQzuMxcM0yhuwDYA2+P3Ntp72kMddFbMPtuNUE6Y1ZIUSkvnVj7XTVZ
         t4i0FbEjXK0t1d7Cq/j/XpxuHvXfwM8ZRAOqkYxVBzGPHgrANYgJ+fJ8FLA+01lf4R+r
         Ul1w==
X-Forwarded-Encrypted: i=1; AL+hErEVUbXhbDFSPXOv0vvHL8qnMEMTUQIJe6erQHs9UPMZAadk9ZmVqWyYKidQaDosEGMOniCTxDwa@vger.kernel.org
X-Gm-Message-State: APuU4Z9JbTCjHvIKAglpqtkFUf63eH0cfw5UiSAsIX1PSiDSpQWOkfI7
	lstCGAJzwnoXQgCZ1Ob8UFCFlnCiIHCV7LRwYBvn6uAK5yDOMIafYWfN1d8sXAr1OaOA7NpW7NR
	7a7zS/gURCjDf7JggE9+1IIADaxdOGAXqrDqhEubm
X-Gm-Gg: AYBFou2BpkaFnaLS05/pJvnvdxxq2oVDs9ymnXUQi/WSMYioIVbNQM5gRg/d7kydsqF
	adFWQNSTx+yz2/FwUHN9uSANchtBG1asg+ASnuAW5dowZDKxeglp6LSkq1anNfH2QSTzei2XpeM
	QudoUJs8dlorUu4PDoHvZFYEJlnnM0w7xomvWG6ydqOxkmfFeQXC8Kkd4os7OEcF7YoliAZqgQa
	T19rhgReTZAWbJ2njr3bO1JBzaR2GarLwO2ipC9NpZeLqo5B1LtgSN+zJkpmXU9YcmxuApAYbk9
	MxvQxcltSdgAe/V5OagamzSC/E+QhuRxZoHl3vHLM4LUNdrpIqndgb2Yz7eTHTkFykq+yz3qxfC
	4FwPkm85fXg4ZWncqb5t7DLPxI7kCjcFV5cJJtaBR5qGQ2GAVHnSFp0krsaHFIxR3Uy0fXmynGx
	kD+rzuE/EokxRRhOIVnCtXOrZAuARVEtSa29TN3MEPggVOGag=
X-Received: by 2002:a05:6512:304c:b0:5bf:f81a:f24e with SMTP id
 2adb3069b0e04-5c00bd5bc9cmr144934e87.10.1794217337930; Mon, 09 Nov 2026
 01:42:17 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260922071945.693714-1-fuad.tabba@linux.dev> <20261007074037.316564-1-fuad.tabba@linux.dev>
In-Reply-To: <20261007074037.316564-1-fuad.tabba@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 Nov 2026 09:41:41 +0000
X-Gm-Features: AclHuK_MaYET6PTkt0ZnvA66k0DV_1M55e3jB2HzY2bpxHczb0VPvo1hIAKLqfY
Message-ID: <CA+EHjTzaJx2nV_9YEExgYn7STSP1Kvhsqan8va8M7ba4WtCiqQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] KVM: selftests: Fix incremental build dependencies
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	James Houghton <jthoughton@google.com>, Will Deacon <will@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Sean, Paolo,

Another gentle ping on this series. Is there anything else you'd like
to see before it goes in?

Cheers,
/fuad
