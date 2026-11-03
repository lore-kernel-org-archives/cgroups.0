Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793724702;
	b=AvnuMAQ/AdKmS+xW6/d+1yIBVuYIY/N/TqThXg0QfnX/ilvSV0ofisXC69CA3+ds8MEm
	 IEy1IgtVbzCZ+Yik0rDm7vk/nc7MEyjsT840Ku49arZhg98UNsfKJPW4OpOry2nJtL7gu
	 EPD+cz+dES2tekxviDI9HsgWGBTAAJnzkJXvpV0tOSGNbcDIhfSHA8NXlqzfdK5Mbr6kJ
	 ILVrjB6Gf0aylLGz51/lHbBDph21upxHfsKybI52EyKt30jnzkCr2MaBI49Qr8Akzux6T
	 Nx5uHB3h677PfO/XhP2jTNu9zZAoWIw6eQ49TbNvK9R+MJFfqhYdXPQK7TLexL7vgCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724702;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Content-Type:Date:
	 Message-Id:Cc:Subject:From:To:In-Reply-To:References:
	 Content-Transfer-Encoding:MIME-Version;
	bh=z/+aYEPLoBSp7AxjoxxgYR8cgspXFyNdt6Vr/KNLDmE=;
	b=lIakbp3uSJLo3PLEBtS8J2E+nFI6V0SYd1QntASoy5i61By3Yfx1n6d1VrGTOTGr3Vx+
	 UDA9mZv1Sfxuoyp4O/aUVJ47JB8nBuEef9Wr6o9sXIbfMlB6p0fsgHE7fILw55Y/klVN2
	 R7e/Q8TxODQ9ygDL9ZULeY7eYcyzsc1nPi/8P1fAUEzv6XsakUL3zpMjQVJtwCtbDuyW+
	 cvxygao47Q+IElXsrWr68g8dX6LLQ1CaES7/f/Hsl9j8DkT2gqrQT8RDKApU5A0ox/iqe
	 GVk5SrHcAnBNLeqC8kyTKODJzQ3bup1vv42oihGjZz1zR+G5OtO0VoYbo3DQsIoKDVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eTIFtqdT;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44E9606A33A
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 16:51:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B44E9606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eTIFtqdT
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a064fac8cbso2895548b3a.1
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 08:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793724701; x=1794329501; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z/+aYEPLoBSp7AxjoxxgYR8cgspXFyNdt6Vr/KNLDmE=;
        b=eTIFtqdTdXpA/AfqqKkL10HIQZLcduWeqawGhkY8XSlpOW7wAg7SwK7IyckCmAeC8z
         QZEJnVKKbFm1lme2SYMMxv1HNP1Njw8KJE3QtzbovqqCyntSjZr0OxFCZk8earTy7ZeP
         s5VZOXYH++PjPF1kTEA3lESRC8qsEpTcVQUri9WLAkuFv2cuZix2S1MDadbIk2gWxXcO
         a1CWIRWP4N0snge7OVszIUi9zzUBbb6XW85sc28z+DIK0qUMW3AE1Bt1XJHJEohjeBO9
         ub6LOMq+gg31oFsCGTjAhEdvsMpjkdKA0Yw0Eq/2gp4qZRvsM2ML5GSPlkglQB80sBeL
         ogXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793724701; x=1794329501;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z/+aYEPLoBSp7AxjoxxgYR8cgspXFyNdt6Vr/KNLDmE=;
        b=BfmtZCcP2bYIxZ7NchRCaqbiBciTsdbinC+CKQfkXt0FleWnvGamoAdpubXL/RP8Bo
         ThkUcx/Zwk67jqJgY1DmfAGCCGHBybDSuZkE4D+0B4niE2D9uvswOrqRr6Oac5PJSshp
         lzW1EAe0twTm2+vZIGRtY+UEi+OI2AEnERc3Clr55UWOHnS6VMCiEYJvUPNlQ5fCEe7s
         MwfBNpkg0b25O3etP5e5C1+yz7NhynyDOjrDTEd+mAJKjz6wO0kp4pSbfoWpDhRP07RR
         r3hi8T/y0nk89DVSOjOowRioQ/rOnwAdloTjk34K09wnQZHAhu8Xq3aRJnIye0A4NxIf
         XwRQ==
X-Gm-Message-State: APuU4Z9TlX903BIbOi2IJ1tx4MF/RAF+eHSK4wXZrpEByNyWPI7Ox8H+
	02234EuOVVv90UmrO5OxQCWFs9XKGL1U/9VJfirV1qdMzhW8SP3R+6qw
X-Gm-Gg: AYBFou00T+oi3iwfDZi7JVV7LLU3cTZeRDpT8fvk89Ei4DzgXrTzWYVuk5I+Mbr+rbe
	kbAQaOPy5pjiAbwf15kC68ZzqEY+0DruU83Fk6sFn2k9HxHysrFV81K2sxv6VNOvCLWznpiPu5j
	Y2PstkGhMB3qFLjn/DX2NkQgX2ZaM39XXKl3xY6OYG00SFIFG0cgsj9jHpvJT9Ly77hdoOZLmsL
	vDm9FZlHxVUHRH0B3cCpriQKXtnPfLEIvy+PwzHUr3SVIgHc/ykOAOWP/vNjiOovIxy7CdGRDlB
	o08rDw4on+axgZBy5YDWPJepauilsXGMZuyDbWICT86UVMSENDRvnJVvme/StwfpMbCU2qgrmzZ
	HALNVNPd0gdkVg0JP9NVhTt0S7z5KeeXgJVO3TbsPA5/yllcYS1X5fIBGeplVQprE6+MpFRxeWR
	0DnZej2/4tdzRmhCGGU3F1CI34acu/vK5ThZGc/IWRSQzKAX4H3JHrQgF+r2kwjYxFuBGBMTWrR
	pQi3EwVnWq1KcX0LFbBrgvxyW42q09PJ4YV3JP8ZMxALzu1r0bnBaU/9F7f5AF+drXlADd05wYS
	qMecgYMdzK+60neGSomRPqqU4Z4/ECy/89xcWuuaw3c1lVySkI6NAOb2ffNgmmuZ/tniLM1Jz3A
	OxVJRVFoH7ZAfXMdMufcaG3o8hJjrLCwGdw==
X-Received: by 2002:a05:6a00:3a12:b0:8a0:2cfd:87cb with SMTP id d2e1a72fcca58-8a9bf90ab27mr11070101b3a.43.1793724700510;
        Tue, 03 Nov 2026 08:51:40 -0800 (PST)
Received: from localhost ([153.61.198.249])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8aad77fccffsm3794904b3a.7.2026.11.03.08.51.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 08:51:40 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Nov 2026 16:51:39 +0000
Message-Id: <DMLQC758A2C3.175VOTFQ2Z8HD@gmail.com>
Cc: <cgroups@vger.kernel.org>, <linux-block@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>, <andrii@kernel.org>,
 <eddyz87@gmail.com>, <daniel@iogearbox.net>,
 <linux-kselftest@vger.kernel.org>, <cuitao@kylinos.cn>,
 <ameryhung@gmail.com>
Subject: Re: [RFC PATCH v12 1/4] blk-iocost: add BPF struct_ops cost model
 support
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Tao Cui" <cui.tao@linux.dev>, <tj@kernel.org>, <josef@toxicopanda.com>,
 <axboe@kernel.dk>
In-Reply-To: <20261103132613.1952975-2-cui.tao@linux.dev>
References: <20261103132613.1952975-1-cui.tao@linux.dev> <20261103132613.1952975-2-cui.tao@linux.dev>
Content-Transfer-Encoding: 8bit
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Tue, Nov 03, 2026 at 05:26 AM Tao Cui <cui.tao@linux.dev> wrote:
> @@ -3223,7 +3306,6 @@ static u64 ioc_weight_prfill(struct seq_file *sf, struct blkg_policy_data *pd,
>  	return 0;
>  }
>
> -
>  static int ioc_weight_show(struct seq_file *sf, void *v)

Unrelated change. Tejun pointed at this hunk in v11.

Overall makes sense to me:
Acked-by: Alexei Starovoitov <ast@kernel.org>
