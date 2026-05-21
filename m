Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450D8335BA8;
	Thu, 21 May 2026 02:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779332101; cv=none; b=Lfl7SHnJfpTvAGTixNyooqCS33ZcYlMwdr5nHYRmhmVIhLDCIpClar2+o9ptmPzM82IK+djCtr8T0CdkP0mKVu9kcLY/sBEnuBHDenlk+8FEFEfsaoMoMSCEszlEOLbqDpX7UyrQOZT08xGK0DPdojy11FkEgUY27fXV7r5DF/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779332101; c=relaxed/simple;
	bh=VF4jADP6Qp2yit24T32AaSzjtIiyP3um5UtzDUx/NKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sAVe/4O/8votR1ZJHuN9oEkW+f7hnWlQM8W73DR/LVYQ2LP7U8TfRiYpoB5lsnq6SxQy9pYraudFOLYOc/P1T5eJ9GzeKy1t65YaElhvNQrHPaLwbsQlw81AuV50WhSuQS0CM/X5uPK57tIrlUSPS+QsRRmgMjSA0ATWRR4VCNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 7157194854c011f1aa26b74ffac11d73-20260521
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:5fea1efd-4108-4fad-81ed-31cdef66987c,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:5fea1efd-4108-4fad-81ed-31cdef66987c,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:ff3adfe54a7f705eccf119063bfca7d0,BulkI
	D:260520203343UF2G41NA,BulkQuantity:5,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil
	,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,D
	KP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7157194854c011f1aa26b74ffac11d73-20260521
X-User: cuitao@kylinos.cn
Received: from [192.168.108.130] [(183.242.174.22)] by mailgw.kylinos.cn
	(envelope-from <cuitao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1315444189; Thu, 21 May 2026 10:54:53 +0800
Message-ID: <31179261-64e0-4950-b112-32627d48e734@kylinos.cn>
Date: Thu, 21 May 2026 10:54:49 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] blk-throttle: schedule parent dispatch in tg_flush_bios()
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, josef@toxicpanda.com,
 linux-block@vger.kernel.org, tj@kernel.org
References: <ag2owaQQoigp_fSV@shinmob>
 <20260520142022.1799724-1-cuitao@kylinos.cn> <ag5DjOCrzfD7D_Ln@shinmob>
From: Tao Cui <cuitao@kylinos.cn>
In-Reply-To: <ag5DjOCrzfD7D_Ln@shinmob>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello，

在 2026/5/21 7:39, Shin'ichiro Kawasaki 写道:
> - Machine: QEMU VM on Intel CPU
> - OS: Fedora 44
> - Kernel: v7.1-rc4 + the patch
> - Kernel config: attacehd
> - Blktests: master branch tip, git hash 4974b9ffa99b
> 
> The scsi_debug is set up by blktests for the throtl test group. The module
> parameters are "dev_size_mb=1024 delay=0" as specified in
> _configure_throtl_blkdev() in tests/throtl/rc. Hope these help to recreate the
> failure in your environment.
> 

I investigated this further and was able to reproduce the same failure on a Fedora VM with the same kernel (v7.1-rc4 + this patch):

  throtl/004 (nullb)   [failed]
  throtl/004 (sdebug)  [failed]

This might be caused by a system locale issue. The test script tests/throtl/004 checks for the error message with:

  grep --only-matching "Input/output error" "$FULL"

On my test VM, the locale is set to zh_CN.UTF-8, and dd outputs a translated error message:

  dd: 写入 '/dev/dev_nullb' 时出错: 输入/输出错误

instead of the expected English text. The EIO was correctly delivered — the grep simply didn't match the localized message.
After setting LC_ALL=C, both test cases pass:

  throtl/004 (nullb) (delete disk while IO is throttled)       [passed]
      runtime  0.721s
  throtl/004 (sdebug) (delete disk while IO is throttled)      [passed]
      runtime  0.849s

Could you check if your system has a non-English locale set? 
If the issue persists after running with LC_ALL=C ./check throtl/004, I'll investigate further.

Thanks,
Tao
